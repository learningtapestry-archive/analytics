#!/usr/bin/env ruby

# Copyright 2014 Learntaculous (Hoekstra/Midgley) - All Rights Reserved

# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential

# This script is designed to move user events, in the form of HTML blocks, from
# Redis temporary queue into a Postgres database-backed queue.  Redis will have
# one queue per customer and move it into the Postgres database that 
# corresponds with that customer.  This script is intended to be called by a 
# cron job.

CONFIG_FILE = "config.json"

require 'json'
require 'pg'
require 'redis'
require 'logger'

logger = Logger.new($stdout)

# Read configuration from file, store in config variable (hash)
config = JSON.parse(File.read('config.json'))

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
	pg = PG::Connection.open(config["configuration"]["postgres_connection_string"])
rescue Exception => e
	logger.error("Cannot connect to Postgres, connect url: " + config["configuration"]["postgres_connection_string"] + 
		", error: " + e.message)
	abort()
end

logger.info "I can connect to both Redis and Postgres, now ready to do some work."