require 'open-uri'
require 'json'
require 'nokogiri'

module LT
  module Janitors
    module LearningRegistryExtract class << self
      # Purpose: 
      #   Extract metadata from HTTP/API call to a Learning Registry extraction endpoint(sandbox.learningregistry.org) for a range of dates

      NODE = 'sandbox.learningregistry.org'
      DEFAULT_START_DATE = Date.parse('2015-02-01') # TODO: we need to change this default date
      HTTP_MAX_RETRIES_COUNT = 3

      # start point
      def retrive
        LT::logger.info("#{self.name}: Starting...")

        total_count = 0

        start_date = RawDocumentLog.last.try(:newest_import_date) || DEFAULT_START_DATE
        on_date = start_date

        (start_date..Date.today).each do |date|
          LT::logger.info("#{self.name}: Start to extract records at #{date}.")

          cnt = retrive_records_by_date(date)

          LT::logger.info("#{self.name}: #{cnt} records were extracted at #{date}.")

          total_count += cnt
          on_date = date
        end
        
        LT::logger.info("#{self.name}: Total #{total_count} records were extracted.")

        # create raw_document_log
        row_document_log = RawDocumentLog.create(
          'action'              => 'lr_import',
          'newest_import_date'  => on_date,
        )

        LT::logger.info("#{self.name}: Row document log was created.")

        LT::logger.info("#{self.name}: Success.")
      end # retrive

      def retrive_records_by_date(date)
        cnt = 0
        token = nil

        while true
          target_url = harvest_url(date, token)

          json_data = get_json_data(target_url)
          break unless json_data
          break unless json_data['documents'].kind_of?(Array)

          json_data['documents'].each do |doc|
            resource = doc['resource_data_description']

            raw_document_attrs = {
              'doc_id'              => doc['doc_ID'],
              'active'              => resource['active'],
              'doc_type'            => resource['doc_type'],
              'doc_version'         => resource['doc_version'],
              'identity'            => resource['identity'],
              'keys'                => resource['keys'],
              'payload_placement'   => resource['payload_placement'],
              'payload_schema'      => resource['payload_schema'],
              'resource_data_type'  => resource['resource_data_type'],
              'resource_locator'    => resource['resource_locator'],
              'raw_data'            => resource.to_json,
            }

            # check whether resource_data type is json, xml or string
            if resource['resource_data'] # if resource_data is exist
              if resource['resource_data'].kind_of?(Hash) # it's json data
                raw_document_attrs['resource_data_json'] = resource['resource_data'].to_json

              elsif Nokogiri::XML(resource['resource_data']).errors.empty? and !resource['resource_data'].include?('!DOCTYPE') # check whether it's xml or not
                raw_document_attrs['resource_data_xml'] = resource['resource_data']

              else
                raw_document_attrs['resource_data_string'] = resource['resource_data']
              end
            end

            if process_raw_document(raw_document_attrs)
              cnt += 1
            end
          end # json_data['documents'].each do |doc|

          token = json_data['resumption_token']

          break if token.nil? # there is no more records after this page.
        end # while true

        cnt
      end # retrive_records_by_date

      # save attributes to the raw_documents table
      def process_raw_document(attrs)
        return if RawDocument.find_by_doc_id(attrs['doc_id'])

        raw_document_record = RawDocument.new(attrs)
        raw_document_record.save
      end

      # parse JSON data from 3rd party api url
      def get_json_data(url)
        tries = 0

        # open 3rd party api url
        begin
          buffer = open(url).read
        rescue OpenURI::HTTPError => e
          LT::logger.error("LearningRegistryExtract: Failed to open #{url}, message: #{e.message}.")
          tries += 1

          if tries > HTTP_MAX_RETRIES_COUNT
            LT::logger.error("LearningRegistryExtract: Failed to extract data at #{date}.")
            return
          end
        end

        # parse JSON data
        begin
          json_data = JSON.parse(buffer)  
        rescue JSON::ParserError
          LT::logger.error("LearningRegistryExtract: Failed to parse JSON data at #{date}.")
          return 
        end

        json_data
      end


      def harvest_url(from, token = nil)
        url = "http://#{NODE}/slice?from=#{from.strftime('%Y-%m-%d')}"
        url = "#{url}&resumption_token=#{token}" if token

        url
      end

    end; end # LearningRegistryExtract
  end # Janitors
end
