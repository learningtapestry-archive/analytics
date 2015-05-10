require 'uri'
require 'time'

module Analytics
  module Utils
    class YoutubeDataAdapter
      def initialize(video, api_key)
        @video = video
        @api_key = api_key
      end

      def import!
        data = JSON.parse(api_call.body, symbolize_names: true)

        @data = data[:items].first

        @video.update!(adapted_attributes)
      end

      private

      def adapted_attributes
        {
          title: title,
          description: description,
          category: category,
          publisher: publisher,
          views: views,
          like_count: like_count,
          dislike_count: dislike_count,
          favorite_count: favorite_count,
          comment_count: comment_count,
          video_length: video_length,
          published_on: published_on,
          updated_on: updated_on
        }
      end

      def api_call
        uri = URI("https://www.googleapis.com/youtube/v3/videos?#{query}")

        response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          http.request(Net::HTTP::Get.new(uri))
        end

        return response if response.code == '200'

        raise LT::APIRequestFailure.new("Youtube Data API: #{response.body}")
      end

      def query
        snip = 'snippet(title,description,categoryId,channelTitle,publishedAt)'
        info = 'contentDetails(duration)'
        stat = 'statistics(*)'
        rec = 'recordingDetails(recordingDate)'
        params = {
          id: @video.external_id,
          key: @api_key,
          part: 'snippet,statistics,contentDetails,recordingDetails',
          fields: "items(#{snip},#{stat},#{info},#{rec})"
        }

        URI.encode_www_form(params)
      end

      def title
        @data[:snippet][:title]
      end

      def description
        @data[:snippet][:description]
      end

      def category
        @data[:snippet][:categoryId]
      end

      def publisher
        @data[:snippet][:channelTitle]
      end

      def published_on
        Time.iso8601(@data[:snippet][:publishedAt])
      end

      def video_length
        @data[:contentDetails][:duration]
      end

      def updated_on
        return published_on unless @data[:recordingDetails]

        Time.iso8601(@data[:recordingDetails][:recordingDate])
      end

      def views
        @data[:statistics][:viewCount]
      end

      def like_count
        @data[:statistics][:likeCount].to_i
      end

      def dislike_count
        @data[:statistics][:dislikeCount].to_i
      end

      def favorite_count
        @data[:statistics][:favoriteCount].to_i
      end

      def comment_count
        @data[:statistics][:commentCount].to_i
      end
    end
  end
end
