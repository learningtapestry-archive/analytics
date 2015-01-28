require 'active_record'
require 'pg'
require 'json'
require 'pry'
require 'logger'
require './lib/model/document'

module LRProcessor

  def self.process_directory(directory)
    throw 'Directory not specified' if directory.nil?
    throw 'Directory not found' if !Dir.exists?(directory)

    enviroment = ENV['RACK_ENV'] ? ENV['RACK_ENV'] : 'development'
    dbconfig = YAML::load(File.open('config/database.yml'))[enviroment]
    ActiveRecord::Base.establish_connection(dbconfig)
    logger = Logger.new('error.log')

    Dir.glob(directory + '/**/*/').each do |dir|
      Dir.glob(dir + '*.json').each do |file|
        file = File.expand_path(file).clone
        file_contents = IO.read(file)
        json = JSON.parse(file_contents)
        doc = Document.new
        doc.doc_id = json['doc_ID'].to_s
        doc.file_location = file.to_s
        doc.full_record = file_contents.to_s
        if json['resource_data_description']
          data = json['resource_data_description']
          doc.doc_type = data['doc_type'].to_s if data['doc_type']
          doc.resource_locator = data['resource_locator'].to_s if data['resource_locator']
          doc.resource_data = data['resource_data'].to_s if data['resource_data']
          doc.resource_data_type = data['resource_data_type'].to_s if data['resource_data_type']
          doc.keys = data['keys'].to_s if data['keys']
          doc.tos = data['TOS'].to_s if data['TOS']
          doc.revision = data['_rev'].to_s if data['_rev']
          doc.payload_schema_locator = data['payload_schema'].to_s if data['payload_schema_locator']
          doc.payload_placement = data['payload_placement'].to_s if data['payload_placement']
          doc.payload_schema = data['payload_schema'].to_s if data['payload_schema']
          doc.node_timestamp = data['node_timestamp'].to_s if data['node_timestamp']
          doc.digital_signature = data['digital_signature'].to_s if data['digital_signature']
          doc.create_timestamp = data['create_timestamp'].to_s if data['create_timestamp']
          doc.doc_version = data['doc_version'].to_s if data['doc_version']
          doc.identity = data['identity'].to_s if data['identity']
        end

        begin
          doc.save
        rescue Exception => e
          logger.error "File #{file}, error: #{e.message}"
        end
      end
    end
  end
end
