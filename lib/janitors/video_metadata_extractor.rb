require 'janitors/extractor'

require 'utils/youtube_adapter'

module Analytics
  module Janitors
    #
    # Imports Video metadata from youtube
    #
    class VideoMetadataExtractor
      include Extractor

      def unprocessed
        Video.unprocessed
      end

      def process_one(video)
        Utils::YoutubeAdapter.new(video).import!
      end
    end
  end
end
