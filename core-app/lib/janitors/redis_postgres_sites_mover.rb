require './lib/lt_base.rb'
require 'json'
require File::join(LT::lib_path, 'util', 'redis_server.rb')

module LT
	module Janitors
		module RedisPostgresSitesMover
			class << self
				def extract

					# TODO:  Loop this
					
					redis_message = LT::RedisServer::raw_message_pop

					if redis_message then
						redis_message = JSON.parse(redis_message)

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
					      	new_site = Site.create
					      	new_site.url = approved_site.url
					      	new_site.display_name = approved_site.site_name
					      	new_site.save
					      	site = new_site.dup
					      end # site

					      page = Page.where(:url=> url).first
					      if !page then
					      	new_page = Page.create
					      	new_page.url = url
					      	new_page.site_id = site.id
					      	new_page.save
					      	page = new_page.dup
					      end # page

					      begin 
					      page_visit = PagesVisited.create
					      page_visit.user_id = api_key_postgres.user_id
					      page_visit.page_id = page.id
					      page_visit.date_visited = timestamp
					      if action == "verbs/viewed" then
					      	page_visit.time_active = redis_message["user"]["action"]["value"]["time"]
					      end #action
					      page_visit.save

						    rescue Exception => e 
						    	puts e
						    end

					    else
					    	puts "Invalid approved_site"
					    end # approved_site
						else
							puts "Invalid API key"
						end # api_key_postgres
					end # redis_message
				end # extract
			end # class << self
		end # RedisPostgresMover
	end # Janitors
end
