
module LT
	module Janitors
		module RawMessagesExtract class << self
			# convert raw_messages table records to page_visits
			#  finds all records in raw_messages that haven't been processed for page_visits
			#  translates as appropriate into page_visit records
			#  marks these records as having been processed
			MAX_RAW_MESSAGE_TRANSACTION_LENGTH = 200
			def raw_messages_to_page_visits
				num_transactions = 0
				RawMessage.transaction do
					RawMessage.find_new_page_visits.each do |raw_page_visit|
						PageVisit.create_from_raw_message(raw_page_visit)
						num_transactions += 1
						break if num_transactions > MAX_RAW_MESSAGE_TRANSACTION_LENGTH
					end 
				end # RawMessage.transaction
				{number_of_records: num_transactions}
			end # raw_messages_to_page_visits
		end; end # RawMessagesExtract

		module RedisPostgresExtract class << self
			MAX_REDIS_RAW_MESSAGE_QUEUE = 200
			# pulls raw_messages from redis and saves them into raw_messages table
			def redis_to_raw_messages
				total_msg_count = 0
				RawMessage.transaction do
					while raw_json_msg = LT::RedisServer::raw_message_pop do
						break if total_msg_count > MAX_REDIS_RAW_MESSAGE_QUEUE
						RawMessage.create_from_json(raw_json_msg)
						total_msg_count +=1
					end # while..
				end # transaction
				{number_of_records: total_msg_count}
			end # redis_to_raw_messages
		end; end # RedisPostgresExtract
	end # Janitors
end
