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

        loop do
          errors += 1 unless partial_report(messages_queue.pop)
          processed += 1

          break if messages_queue.empty? || processed >= batch_size
        end

        final_report(processed, errors)
      end

      def process_one(json_msg)
        RawMessage.create!(JSON.parse(json_msg))
      end
    end
  end
end
