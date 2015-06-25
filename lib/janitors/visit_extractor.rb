require 'janitors/extractor'

module Analytics
  module Janitors
    #
    # Extracts PageVisit objects from RawMessage's
    #
    class VisitExtractor
      include Extractor

      def unprocessed
        RawMessage.page_msgs(batch_size)
      end

      def process_one(raw_msg)
        raw_msg.process_as_page
      end
    end
  end
end
