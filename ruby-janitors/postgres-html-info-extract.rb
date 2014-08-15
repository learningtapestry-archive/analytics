#!/usr/bin/env ruby

# Copyright 2014 Learntaculous (Hoekstra/Midgley) - All Rights Reserved

# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential

# This script is designed to parse raw HTML blocks in a Postgres queue to 
# extract information necessary into a table to support decisions when using 
# online learning products.  This script is intended to be called by a cron 
# job.

# STATUS:  PROTOTYPE and WORK IN PROGRESS

require 'rubygems'
require 'active_record'
require 'yaml'
require 'htmlentities'
require 'nokogiri'
require './lib/util/configuration.rb'
require './lib/model/raw_message.rb'
require './lib/model/statement.rb'
require './lib/model/approved_site.rb'
require './lib/model/extraction_map.rb'

logger = Logger.new($stdout)

# Connect to Postgres
begin
	dbconfig = YAML::load(File.open('db/config.yml'))
	ActiveRecord::Base.establish_connection(dbconfig['development'])
rescue Exception => e
	logger.error("Cannot connect to Postgres, connect string: #{dbconfig['development']}, error: #{e.message}")
	abort()
end

raw_messages = RawMessage.where(status: "READY")  #TODO:  Consider putting limit to not grab unmanagable amount of records

approved_sites = ApprovedSite.all

#approved_sites.each do |approved_site|
#	puts approved_site.extraction_maps.inspect
#end

raw_messages.each do |raw_message|
	html = Nokogiri.parse(raw_message.html)
	hash_id = "gnqCcQuzkiGYOOo3"  #TODO: embed into Chrome Extension, hardcoding until

	approved_site = approved_sites.find_by hash_id: hash_id

	if approved_site then
		begin


			# Check if our extraction map is an iterator, if so, iterate statement, if not, extract one statement
			if approved_site.extraction_maps.where("parent_extraction_map_id IS NOT NULL").count > 0  &&
				approved_site.extraction_maps.where("target_field IS NULL AND parent_extraction_map_id IS NULL").count == 1 then

				iterator_map = approved_site.extraction_maps.where("target_field IS NULL AND parent_extraction_map_id IS NULL")

				if iterator_map && iterator_map.count == 1 then
					iterator = html.xpath(iterator_map[0].xpath_selector)

					iterator.each do |snippet|
						statement = Statement.new
						statement.user_id = 1   #TODO: Get actual user_id
						statement.actor = raw_message.email
						statement.verb = raw_message.action

						# Extract non-repeating elements
						snippet_maps = approved_site.extraction_maps.where("parent_extraction_map_id IS NULL AND target_field IS NOT NULL")
						snippet_maps.each do |snippet_map|
							statement[snippet_map.target_field] = html.at_xpath(snippet_map.xpath_selector).content
						end

						# Extract repeating elements
						snippet_maps = approved_site.extraction_maps.where("parent_extraction_map_id IS NOT NULL AND target_field IS NOT NULL")
						snippet_maps.each do |snippet_map|
							statement[snippet_map.target_field] = snippet.at_xpath(snippet_map.xpath_selector).content
						end

						statement.date_created = DateTime.now
						statement.save
						raw_message.status = "OK"
						raw_message.date_updated = DateTime.now
						raw_message.save
					end
				else
					statement = Statement.new
					statement.user_id = 1   #TODO: Get actual user_id
					statement.actor = raw_message.email
					statement.verb = raw_message.action

					# Extract non-repeating elements
					snippet_maps = approved_site.extraction_maps.where("parent_extraction_map_id IS NULL")
					snippet_maps.each do |snippet_map|
						statement[snippet_map.target_field] = html.at_xpath(snippet_map.xpath_selector)
					end

					statement.date_created = DateTime.now
					statement.save
					raw_message.status = "OK"
					raw_message.date_updated = DateTime.now
					raw_message.save
				end
			end
		rescue Exception => e
			logger.error("Error parsing raw message: #{raw_message.id}, error: #{e.message})")
			raw_message.status = "ERROR"
			raw_message.date_updated = DateTime.now
			raw_message.save
		end
	end
end