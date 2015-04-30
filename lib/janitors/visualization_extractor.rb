require 'janitors/extractor'

module Analytics
  module Janitors
    #
    # Extracts video Visualization's from RawMessage's
    #
    class VisualizationExtractor
      include Extractor

      def unprocessed
        RawMessage.video_msgs(batch_size)
      end

      def process_one(record)
        record.process_as_video
      end
    end
  end
end
