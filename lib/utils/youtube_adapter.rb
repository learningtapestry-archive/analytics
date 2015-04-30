require 'nokogiri'
require 'open-uri'

module Analytics
  module Utils
    class NoResponseFromYoutubeAPI < StandardError; end

    class YoutubeAdapter
      def initialize(video)
        @video = video
      end

      def import!
        @doc = Nokogiri::XML(open(api_endpoint))
        fail NoResponseFromYoutubeAPI unless @doc

        @doc.remove_namespaces!

        @video.update!(adapted_attributes)
      end

      private

      def adapted_attributes
        {
          title: title,
          description: description,
          category: category,
          views: views,
          publisher: publisher,
          rating: rating,
          raters: raters,
          video_length: video_length,
          published_on: published_on,
          updated_on: updated_on
        }
      end

      def api_endpoint
        "http://gdata.youtube.com/feeds/api/videos/#{@video.external_id}"
      end

      def title
        @doc.xpath('/entry/title')[0].text.strip
      end

      def description
        @doc.xpath('/entry/group/description').text
      end

      def category
        @doc.xpath('/entry/group/category').text
      end

      def views
        @doc.xpath('/entry/statistics')[0].attributes['viewCount'].value.to_i
      end

      def publisher
        @doc.xpath('/entry/author/name').text
      end

      def rating
        @doc.xpath('/entry/rating')[0].attributes['average'].value.to_f
      end

      def raters
        @doc.xpath('/entry/rating')[0].attributes['numRaters'].value.to_i
      end

      def video_length
        seconds = @doc.xpath('//duration')[0].attributes['seconds'].value.to_i

        Time.at(seconds).utc.strftime('%H:%M:%S')
      end

      def published_on
        DateTime.parse(@doc.xpath('/entry/published')[0].text)
      end

      def updated_on
        DateTime.parse(@doc.xpath('/entry/updated')[0].text)
      end
    end
  end
end
