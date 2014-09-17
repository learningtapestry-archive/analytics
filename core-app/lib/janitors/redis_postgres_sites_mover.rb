require './lib/lt_base.rb'
require 'json'
require File::join(LT::lib_path, 'util', 'redis_server.rb')

module LT
	module Janitors
		module RedisPostgresSitesMover
			class << self
				def extract


				end # extract
			end # class << self
		end # RedisPostgresMover
	end # Janitors
end

=begin

CONFIG_FILE = "./config/config.json"

require 'json'
require 'pg'
require 'redis'
require 'logger'
require 'rubygems'
require 'active_record'
require 'yaml'
require 'htmlentities'
require './lib/model/raw_message.rb'

logger = Logger.new($stdout)
html_decoder = HTMLEntities.new

config = Configuration.new(File.expand_path(CONFIG_FILE)) # Load Configuration class with a normalized full file path

# If configuration is not fully initialized, then log error and abort execution
if !config.is_initialized then
	logger.error("Configuration not initialized, error: #{config.error_message}")
	abort()
end

# Connect to Redis
redis = Redis.new(:url => config.redis_url)

begin
	redis.ping # connect to Redis server
rescue Exception => e
	logger.error("Cannot connect to Redis, connect url: #{redis_url}, error: #{e.message}")
	abort()
end

# Connect to Postgres
begin
	dbconfig = YAML::load(File.open('db/config.yml'))
	ActiveRecord::Base.establish_connection(dbconfig['development'])
rescue Exception => e
	logger.error("Cannot connect to Postgres, connect string: #{dbconfig['development']}, error: #{e.message}")
	abort()
end

counter = 0 # For unique filenames upon error
# If the Redis queue has messages, RPOP messages until empty
if (redis.llen config.redis_queue_name) > 0 then
	message = redis.rpop config.redis_queue_name
	until message.nil?
		begin
			json_message = JSON.parse(message)
			if json_message.key?("user") &&
				json_message["user"].key?("email") &&
				json_message["user"].key?("apiKey") &&
				json_message["user"].key?("action") &&
				json_message["user"]["action"].key?("id") &&
				json_message["user"].key?("url") &&
				json_message["user"]["url"].key?("id") then

				raw_message = RawMessage.new
				raw_message.status = "READY"
				raw_message.email = json_message["user"]["email"]
				raw_message.action = json_message["user"]["action"]["id"]
				raw_message.api_key = json_message["user"]["apiKey"]
				raw_message.url = json_message["user"]["url"]["id"]
				raw_message.date_captured = json_message["user"]["timestamp"]
				raw_message.date_created = Time.now

				if json_message["user"].key?("html") then
					raw_message.html = html_decoder.decode json_message["user"]["html"]
				end

				begin
					raw_message.save
				rescue Exception => e
					file_name = Time.now.strftime('%Y%m%d%H%M%S%L') + "-#{counter}.json"
					logger.warn("Cannot save message into database, dumping to #{message_dberror_dir}/#{file_name}, error: #{e.message}")
					File.open(message_dberror_dir + '/' + file_name, 'w') {|f| f.write(message) } # Dump to disk
				end
			end
		rescue Exception => e
			file_name = Time.now.strftime('%Y%m%d%H%M%S%L') + "-#{counter}.json"
			logger.warn("Cannot parse message into JSON, dumping to #{message_error_dir}/#{file_name}, error: #{e.message}")
			File.open(message_error_dir + '/' + file_name, 'w') {|f| f.write(message) } # Dump to disk
		end

		message = redis.rpop redis_queue_name
		counter += 1
	end
end
=end