require 'active_record'
require 'pg'
require 'json'
require 'pry'
require 'logger'
require 'digest/md5'
require 'objspace'

Dir['./lib/model/*.rb'].each {|file| require file }

module LRIndexer

  @enviroment = ENV['RACK_ENV'] ? ENV['RACK_ENV'] : 'development'
  @dbconfig = YAML::load(File.open('config/database.yml'))[@enviroment]
  ActiveRecord::Base.establish_connection(@dbconfig)
  @logger = Logger.new('error.log')

  EXCLUDE_TAGS = [ 'http://www.freesound', 'oai:nsdl.org', 'hdl:', 'moreid:', 'work-cmr-id:', 'sdt.sulinet.hu:', 'DIA (Digital Image Archive):', 'oai:oai:', 'lre:',
                        'CNDP-numeribase:', 'fnbe:', 'MERLI:', 'teachers domain:' ]

  def self.parse_tags
    count = 0

    Document.find_in_batches(batch_size: 1000, start: 400000) do |docs|
      docs.each do |doc|
        keys = JSON.parse doc.keys if doc.keys
        begin
          ActiveRecord::Base.transaction do
            keys.each do |key|
              unless starts_with_in_array(key, EXCLUDE_TAGS)
                #tag = Tag.find_or_create_by(name: key)
                #doc.tags << tag
              end
            end
            #doc.save
          end
        rescue Exception => e
          puts e
          @logger.error e
        end if keys
        count += 1
        puts "#{count} at #{doc.id}" if count % 1000 == 0
      end
    end
  end

  def self.parse_payload_schemas
    Document.find_in_batches(:batch_size =>100) do |docs|
      docs.each do |doc|
        puts doc.id
        payload_schemas = JSON.parse doc.payload_schema if doc.payload_schema
        if payload_schemas
          begin
            ActiveRecord::Base.transaction do
              payload_schemas.each do |payload_schema|
                payload = PayloadSchema.find_or_create_by(name: payload_schema)
                doc.payload_schemas << payload
                doc.save
              end
            end
          rescue Exception => e
            @logger.error e
          end
        end
      end
    end
  end

  def self.parse_identities
    conn = PG::Connection.new(host: @dbconfig['host'], dbname: @dbconfig['database'], user: @dbconfig['username'], password: @dbconfig['password'])
    results = conn.exec('SELECT id, identity FROM documents ORDER BY id')

    count = 0
    hashes = {}

    sql_string = 'INSERT INTO identities (submitter, submitter_type, curator, signer, owner, hash) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id'
    conn.prepare('insert_identity', sql_string)

    sql_string = 'UPDATE documents SET identity_id = $1 WHERE id = $2'
    conn.prepare('update_document', sql_string)

    snap_time = Time.now

    results.each do |result|
      id = result['id']
      hash = Digest::MD5.hexdigest(result['identity'])

      begin
        params = Array.new(6)
        identity = eval result['identity']
        unless hashes[hash]
          params[0] = identity['submitter'] if identity['submitter']
          params[0] = identity['submiter'] if identity['submiter'] # Correcting for Junyo error
          params[1] = identity['submitter_type'] if identity['submitter_type']
          params[2] = identity['curator'] if identity['curator']
          params[3] = identity['signer'] if identity['signer']
          params[4] = identity['owner'] if identity['owner']
          params[5] = hash
          insert_result = conn.exec_prepared('insert_identity', params)
          identity_id = insert_result[0]['id']
          hashes[hash] = identity_id
        end
      rescue Exception => ex
        @logger.error ex
        puts ex
      end

      conn.exec_prepared('update_document', [ hashes[hash], id ])
      count += 1
      if count % 10000 == 0
        puts "#{count} - #{Time.now-snap_time}"
        snap_time = Time.now
      end
    end

  end

  def self.parse_alignments
    conn = PG::Connection.new(host: @dbconfig['host'], dbname: @dbconfig['database'], user: @dbconfig['username'], password: @dbconfig['password'])
    record_count = 0
    limit = 10000
    snap_time = Time.now
    json = nil

    sql_string = 'SELECT id FROM alignments WHERE hash=$1'
    conn.prepare('select_alignment', sql_string)

    sql_string = 'INSERT INTO alignments (framework, name, type, description, url, hash) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id'
    conn.prepare('insert_alignment', sql_string)

    sql_string = 'INSERT INTO documents_alignments (document_id, alignment_id) VALUES ($1, $2)'
    conn.prepare('insert_doc_align', sql_string)

    rd_keys = []
    align_keys = {}

    while true do
      results = conn.exec("SELECT id, full_record FROM documents WHERE id BETWEEN #{record_count} AND #{record_count+limit} ")
      break if results.count == 0

      results.each do |result|
        id = result['id']
        begin
          json = JSON.parse(result['full_record'], symbolize: true)
          resource_data = json['resource_data_description']['resource_data']
          if resource_data.is_a? Hash
            resource_data.keys.each do |key|
              rd_keys.push key unless rd_keys.include? key

              if key == 'educationalAlignment'
                if resource_data[key].is_a? Array
                  resource_data[key].each do |ed_align|
                    arr = alignment_array(ed_align)
                    align_id = 0
                    if align_keys[arr[5]]
                      align_id = align_keys[arr[5]]
                    else
                      align_id = conn.exec_prepared('select_alignment', [arr[5]])
                      align_id.count == 0 ? align_id = conn.exec_prepared('insert_alignment', arr)[0]['id'] : align_id = align_id[0]['id']
                      align_keys[arr[5]] = align_id
                    end
                    conn.exec_prepared('insert_doc_align', [id, align_id])
                  end
                else
                  @logger.warn "Unknown educationAlignment for #{result.id}"
                  puts "Unknown educationAlignment for #{result.id}"
                end
              end
            end
          end
        rescue Exception => ex
          @logger.error ex
          puts ex
        end
      end

      puts "#{record_count} - #{Time.now-snap_time}"
      snap_time = Time.now
      record_count += limit
    end

    #puts rd_keys
  end

# parse_identities


  def self.alignment_array(alignment_json)
    retval = Array.new(6)
    retval[0] = alignment_json['educationalFramework'] if alignment_json['educationalFramework']
    retval[1] = alignment_json['targetName'] if alignment_json['targetName']
    retval[2] = alignment_json['alignmentType'] if alignment_json['alignmentType']
    retval[3] = alignment_json['targetDescription'] if alignment_json['targetDescription']
    retval[4] = alignment_json['targetUrl'] if alignment_json['targetUrl']

    5.times do |index|
      retval[index] = retval[index][0] if retval[index].is_a? Array and retval[index].length == 1
    end

    retval[5] = Digest::MD5.hexdigest(retval.to_s)
    retval
  end


  parse_alignments

  def self.starts_with_in_array(value_string, value_array)
    value_array.each do |array_value|
      if value_string.start_with? array_value then
        return true
      end
    end
    return false
  end

end
