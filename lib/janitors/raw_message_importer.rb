require 'janitors/importer'
require 'helpers/redis'

module Analytics
  module Janitors
    #
    # Extracts json messages stored in Redis into RawMessage records
    #
    class RawMessageImporter
      include Helpers::Redis
      include Importer

      #
      # Check errors
      #
      def import
        processed, errors = 0, 0

        messages = messages_queue.fetch_batch(batch_size)

        messages.reverse_each do |message|
          errors += 1 unless partial_report(message)
          processed += 1
        end

        final_report(processed, errors)
      end

      def process_one(json_msg)
        message = JSON.parse(json_msg)
        message['username'] = CGI::unescape(message['username'])
        existing_message = get_existing_view_message(message)

        if existing_message
          existing_message.update_attributes!(action: message['action'], captured_at: message['captured_at'])
        else
          RawMessage.create!(message)
        end
      end

      private
      def get_existing_view_message(message)
        if message['verb'] == 'viewed'
          RawMessage.page_msgs(batch_size).last_message_in_visit(message['url'],
                                                                 message['username'],
                                                                 message['heartbeat_id'])
        end
      end
    end
  end
end
