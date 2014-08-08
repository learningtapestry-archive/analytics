#!/usr/bin/env ruby

# Copyright 2014 Learntaculous (Hoekstra/Midgley) - All Rights Reserved

# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential

# This script is designed to move user events, in the form of HTML blocks, from
# Redis temporary queue into a Postgres database-backed queue.  Redis will have
# one queue per customer and move it into the Postgres database that 
# corresponds with that customer.  This script is intended to be called by a 
# cron job.

CONFIG_FILE = "config/config.json"

require 'json'
require 'pg'
require 'redis'
require 'logger'
require 'rubygems'
require 'active_record'
require 'yaml'

class RawMessage < ActiveRecord::Base
end

logger = Logger.new($stdout)

# Read configuration from file, store in config variable (hash)
config = JSON.parse(File.read(CONFIG_FILE))

# If configuration doesn't parse or doesn't contain first element, stop and throw error
if !config || !config["configuration"] then
	logger.error("Configuration file (config.json) not found or invalid format.")
	abort()
end

# Connect to Redis
redis = Redis.new(:url => config["configuration"]["redis_url"])
begin
	redis.ping # connect to Redis server
rescue Exception => e
	logger.error("Cannot connect to Redis, connect url: " + config["configuration"]["redis_url"] + 
		", error: " + e.message)
	abort()
end

# Connect to Postgres
begin
	dbconfig = YAML::load(File.open('db/config.yml'))
	ActiveRecord::Base.establish_connection(dbconfig['development'])
rescue Exception => e
	logger.error("Cannot connect to Postgres, connect string: " + dbconfig['development'] + 
		", error: " + e.message)
	abort()
end


#=begin
logger.info "I can connect to both Redis and Postgres, now ready to do some work."

sample_message = RawMessage.new
sample_message.status = "OK"
sample_message.api_key = "123"
sample_message.email = "jasonhoekstra@gmail.com"
sample_message.action = "viewed/view"
sample_message.save
puts sample_message.id
#=end
