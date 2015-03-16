
module LT
	module Janitors

		module RedisPostgresExtract class << self
			MAX_REDIS_RAW_MESSAGE_QUEUE = 2000
			# pulls raw_messages from redis and saves them into raw_messages table
			def redis_to_raw_messages
				total_msg_count = 0; total_msg_failed = 0
				RawMessage.transaction do
					while raw_json_msg = LT::RedisServer::raw_message_pop do
						break if total_msg_count > MAX_REDIS_RAW_MESSAGE_QUEUE
						begin
							raw_message = RawMessage.create_from_json(raw_json_msg)
							LT::logger.info("RawMessagesExtract: Successful extract Redis to PG raw message, raw msg ID: #{raw_message.id}")
						rescue Exception => e
							LT::logger.error("RawMessagesExtract: Failed extract Redis to PG raw message, exception: #{e.message}")
							total_msg_failed += 1						
						end
						total_msg_count +=1
					end # while..
				end # transaction
				LT::logger.info("RawMessagesExtract: Finished extract Redis to PG raw messages, total count: #{total_msg_count}, failures: #{total_msg_failed}")
				{number_of_records: total_msg_count}
			end # redis_to_raw_messages
    end; end # RedisPostgresExtract

    module RawMessagesExtract class << self
    # convert raw_messages table records to page_visits
    #  finds all records in raw_messages that haven't been processed for page_visits
    #  translates as appropriate into page_visit records
    #  marks these records as having been processed
      MAX_RAW_MESSAGE_TRANSACTION_LENGTH = 2000
      def raw_messages_to_page_visits
        num_transactions = 0; num_failed = 0
        RawMessage.transaction do
          RawMessage.find_new_page_visits.each do |raw_page_visit|
            begin
              PageVisit.create_from_raw_message(raw_page_visit)
              LT::logger.info("RawMessagesExtract: Successful extract PG raw message to page visit, raw msg ID: #{raw_page_visit.id}")
            rescue Exception => e
              LT::logger.error("RawMessagesExtract: Failed extract PG raw message to page visit, raw msg ID: #{raw_page_visit.id}, exception: #{e.message}")
              num_failed += 1
            end
            num_transactions += 1
            break if num_transactions > MAX_RAW_MESSAGE_TRANSACTION_LENGTH
          end # RawMessage.find_new_page_visits.each
        end # RawMessage.transaction
        LT::logger.info("RawMessagesExtract: Finished extract PG raw message to page visits, transactions: #{num_transactions}, failures: #{num_failed}")
        {number_of_records: num_transactions}
      end # raw_messages_to_page_visits

      def raw_messages_to_video_visits
        num_transactions = 0; num_failed = 0
        RawMessage.transaction do

          current_session_id = ''
          started_time = ''
          paused_count = 0
          end_time = ''
          video_id = ''
          username = ''
          url = ''
          page_url = ''
          org_id = 0

          RawMessage.find_new_video_visits.each do |raw_video_visit|
            begin
              #puts "#{raw_video_visit['session_id']}  #{raw_video_visit['state']}  #{raw_video_visit['video_id']}  #{raw_video_visit['captured_at']}"

              if current_session_id != raw_video_visit['session_id']
                if video_id
                  save_video_view(current_session_id, url, page_url, username, org_id, paused_count, started_time, end_time)
                end

                current_session_id = raw_video_visit['session_id']
                paused_count = 0

                user = User.find_or_create_by(username: username, organization_id: org_id)
              end

              org_id = raw_video_visit['org_id']
              video_id = raw_video_visit['video_id']
              username = raw_video_visit['username']
              url = raw_video_visit['video_id']
              page_url = raw_video_visit['url']

              case raw_video_visit['state']
                when 'playing'
                  started_time = raw_video_visit['captured_at']
                when 'ended'
                  end_time = raw_video_visit['captured_at']
                when 'paused'
                  paused_count += 1
              end

              # VideoView.create_from_raw_message(raw_video_visit)
              LT::logger.debug("RawMessagesExtract.raw_messages_to_video_visits: Successful extract PG raw message to video visit, raw msg ID: #{raw_video_visit['video_id']}")
            rescue Exception => e
              puts e
              LT::logger.error("RawMessagesExtract.raw_messages_to_video_visits: Failed extract PG raw message to video visit, raw msg ID: #{raw_video_visit['video_id']}, exception: #{e.message}")
              num_failed += 1
            end
            num_transactions += 1
            break if num_transactions > MAX_RAW_MESSAGE_TRANSACTION_LENGTH
          end # RawMessage.find_new_video_visits.each

          save_video_view(current_session_id, url, page_url, username, org_id, paused_count, started_time, end_time)

        end # RawMessage.transaction
        LT::logger.info("RawMessagesExtract: Finished extract PG raw message to video visits, transactions: #{num_transactions}, failures: #{num_failed}")
        {number_of_records: num_transactions}
      end

      def save_video_view(current_session_id, url, page_url, username, org_id, paused_count, started_time, end_time)
        if current_session_id.length == 36
          begin
            user = User.find_or_create_by(username: username, organization_id: org_id)

            v = Video.find_or_create_by_url(url)
            data = {}
            data[:url] = page_url
            page = Page.find_or_create_by_url(data)

            vv = VideoView.new
            vv.video_id = v.id
            vv.page_id = page.id
            vv.user_id = user.id
            vv.time_started = started_time
            vv.time_ended = end_time
            vv.paused_count = paused_count
            vv.save
            LT::logger.debug("save_video_view: Finished extract PG raw message to video visits, url: #{url}")
          rescue Expection => e
            LT::logger.error("RawMessagesExtract.save_video_view: Failed insert PG video visit, url: #{url}, exception: #{e.message}")
          end
        end

      end # raw_messages_to_video_visits

    end; end # RawMessagesExtract
	end # Janitors
end
