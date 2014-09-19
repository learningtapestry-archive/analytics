require './lib/lt_base.rb'
require 'json'
require File::join(LT::lib_path, 'util', 'redis_server.rb')

module LT
	module Janitors
		module RedisPostgresSitesMover
			class << self
				def extract
					LT::logger.info("RedisPostgresSitesMover.extract starting")

					message_path = get_message_path
					counter = 1

					# TODO:  Refactor with performance in mind (loop limits)
					while redis_message = LT::RedisServer::raw_message_pop
						begin
							file_name = File::join(File.expand_path(message_path), get_file_name(counter))
							redis_message = JSON.parse(redis_message)
							File.open(file_name, 'w') {|f| f.write(redis_message) }

							username = redis_message["user"]["username"]
							api_key_message = redis_message["user"]["apiKey"]
							site_hash = redis_message["user"]["site_hash"]
							action = redis_message["user"]["action"]["id"]
							timestamp = redis_message["user"]["timestamp"]
							url = redis_message["user"]["url"]["id"]

							api_key_postgres = ApiKey.get_by_api_key(api_key_message)

							if api_key_postgres then
								approved_site = ApprovedSite.get_by_site_hash(site_hash)

								if approved_site then
						      
						      site = Site.where(:url=>approved_site.url).first
						      if !site then
						      	site = Site.create
						      	site.url = approved_site.url
						      	site.display_name = approved_site.site_name
						      	site.save
						      end # site

						      page = Page.where(:url=> url).first
						      if !page then
						      	page = Page.create
						      	page.url = url
						      	page.site_id = site.id
						      	page.save
						      end # page

						      page_visit = PageVisit.create
						      page_visit.user_id = api_key_postgres.user_id
						      page_visit.page_id = page.id
						      page_visit.date_visited = timestamp
						      if action == "verbs/viewed" then
						      	page_visit.time_active = redis_message["user"]["action"]["value"]["time"]
						      end #action
						      page_visit.save
						    else
						    	LT::logger.error("RedisPostgresSitesMover.extract - approved_site not found, message: #{file_name}")
						    end # approved_site
							else
						    	LT::logger.error("RedisPostgresSitesMover.extract - api_key not found, message: #{file_name}")
							end # api_key_postgres
						rescue Exception => e
							LT::logger.error("RedisPostgresSitesMover.extract - unexpected exception, message: #{file_name}, exception: #{e.message}")
						ensure
							counter += 1
						end #begin exception trap
					end # redis_message while loop
					LT::logger.info("RedisPostgresSitesMover.extract - processed #{counter-1} messages")
					LT::logger.info("RedisPostgresSitesMover.extract ending")
				end # extract

			def get_message_path
				today = Time.new.strftime("%Y%m%d").to_s
				daily_path = File::expand_path(File::join(LT::message_path, "/#{today}"))
	      unless File.directory?(daily_path)
	        FileUtils.mkdir_p(daily_path)
	      end
	      daily_path
			end # get_message_path

			def get_file_name(counter)
				counter = counter.to_s.rjust(4, "0")
				now = Time.new.strftime("%H%M%S")
				"#{now}-#{counter}.msg"
			end

			end # class << self
		end # RedisPostgresMover
	end # Janitors
end
