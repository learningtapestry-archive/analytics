
module LT
	module Janitors
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
		end; end # RawMessagesExtract

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
	end # Janitors
end
