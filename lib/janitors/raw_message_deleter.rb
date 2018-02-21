# frozen_string_literal: true

module Analytics
  module Janitors
    #
    # Extracts json messages stored in Redis into RawMessage records
    #
    class RawMessageDeleter
      def run
        RawMessage
          .where('processed_at is not null')
          .where('captured_at < ?', 1.day.ago)
          .delete_all
      end
    end
  end
end

