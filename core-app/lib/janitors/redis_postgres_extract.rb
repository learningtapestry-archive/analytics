
module LT
	module Janitors
		module RawMessagesExtract class << self
			def raw_messages_to_page_visits

				RawMessage.find_new_page_visits.each do |raw_page_visit|
					#raw_page_visit
				end
			end
		end; end # RawMessagesExtract
		module RedisPostgresExtract class << self
			MAX_REDIS_RAW_MESSAGE_QUEUE = 200
			def redis_to_raw_messages
				total_msg_count = 0
				RawMessage.transaction do
					while raw_json_msg = LT::RedisServer::raw_message_pop do
						break if total_msg_count > MAX_REDIS_RAW_MESSAGE_QUEUE
						RawMessage.create_from_json(raw_json_msg)
						total_msg_count +=1
					end # while..
				end # transaction
			end # redis_to_raw_messages

			def extract
				LT::logger.info("RedisPostgresExtract.extract starting")

				message_path = get_message_path
				extract_time = Time.new.strftime("%H%M%S")
				counter = 0

				# TODO:  Refactor with performance in mind (loop limits)
				while redis_message = LT::RedisServer::raw_message_pop
					begin
						file_name = File::join(File.expand_path(message_path), counter.to_s.rjust(6, "0") + ".msg")
						redis_message = JSON.parse(redis_message)
						File.open(file_name, 'w') {|f| f.write(redis_message) }

						username = redis_message["user"]["username"]
						api_key_message = redis_message["user"]["apiKey"]
						site_hash = redis_message["user"]["site_hash"]
						action = redis_message["user"]["action"]["id"]
						timestamp = redis_message["user"]["timestamp"]
						url = redis_message["user"]["url"]["id"]

						if action == "verbs/viewed" || action == "verbs/clicked"
							api_key_postgres = ApiKey.get_by_api_key(api_key_message)

							if api_key_postgres then
								approved_site = ApprovedSite.get_by_site_hash(site_hash)

								if approved_site then
									site = Site.where(url: approved_site.url, display_name: approved_site.site_name).first_or_create
									page = Page.where(url: url, site_id: site.id).first_or_create

						      if action == "verbs/viewed" then
						      	page_visit = PageVisit.create
						      	page_visit.user_id = api_key_postgres.user_id
						      	page_visit.page_id = page.id
						      	page_visit.time_active = redis_message["user"]["action"]["value"]["time"]
						      	page_visit.date_visited = timestamp
							      page_visit.save
						      elsif action == "verbs/clicked"
						      	page_click = PageClick.create
						      	page_click.user_id = api_key_postgres.user_id
						      	page_click.page_id = page.id
						      	page_click.url_visited = redis_message["user"]["action"]["value"]["url"]
						      	page_click.date_visited = timestamp
						      	page_click.save
						      end #action
						    else
						    	LT::logger.error("RedisPostgresExtract.extract - approved_site not found, message: #{file_name}")
						    end # approved_site
							else
						    	LT::logger.error("RedisPostgresExtract.extract - api_key not found, message: #{file_name}")
							end # api_key_postgres
						end # action viewed or clicked
					rescue Exception => e
						LT::logger.error("RedisPostgresExtract.extract - unexpected exception, message: #{file_name}, exception: #{e.message}")
					ensure
						counter += 1
					end #begin exception trap
				end # redis_message while loop
				LT::logger.info("RedisPostgresExtract.extract - processed #{counter} messages") #zero based start, counter+1 in ensure will get proper count
				LT::logger.info("RedisPostgresExtract.extract ending")
			end # extract

			def get_message_path
				today = Time.new.strftime("%Y%m%d").to_s
				daily_path = File::expand_path(File::join(LT::message_path, "/#{today}"))
	      unless File.directory?(daily_path)
	        FileUtils.mkdir_p(daily_path)
	      end
	      daily_path
			end # get_message_path

		end; end # RedisPostgresExtract
	end # Janitors
end
