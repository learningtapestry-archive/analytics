require 'janitors/extractor'

require 'utils/youtube_data_adapter'

module Analytics
  module Janitors
    #
    # Imports Video metadata from youtube
    #
    class VideoMetadataExtractor
      include Extractor

      def initialize(logger, batch_size, config)
        super(logger, batch_size)

        @config = config
      end

      def unprocessed
        Video.unprocessed
      end

      def process_one(video)
        Utils::YoutubeDataAdapter.new(video, @config[:api_key]).import!
      end
    end
  end
end
