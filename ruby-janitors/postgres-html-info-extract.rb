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

raw_messages.each do |raw_message|
	html = Nokogiri.parse(raw_message.html)
	subject_title = html.css('main article div section h1')
	topic_segment = html.css('article.syllabus__topic')

	topic_segment.each do |snippet|
		lesson_title = snippet.css('h4')
		value = snippet.css('span.syllabus__progress')

		puts subject_title[0].content
		puts raw_message.url
		puts lesson_title[0].content
		puts value[0]['value']
		puts "-------------------"
	end
end
