require 'open-uri'
require 'json'
require 'nokogiri'

module LT
  module Janitors
    module WebExtractor class << self

      def fill_youtube_info
        puts 'starting'
        Video.where('title IS NULL AND service_id IS NULL').each do | video |
          document = Nokogiri::HTML(open(video['url']))

          if video['url'].include? 'youtube'
            video.title = document.css('span#eow-title').inner_html.strip!
            video.views = document.css('div.watch-view-count').inner_html
            video.publisher = document.css('div.yt-user-info > a').inner_html
            video.service_id = 'youtube'

            begin
              video.likes = document.css('span#watch-like-dislike-buttons > span > button#watch-like > span.yt-uix-button-content')[0].inner_html
              video.dislikes = document.css('span#watch-like-dislike-buttons > span > button#watch-dislike > span.yt-uix-button-content')[0].inner_html
            rescue
            end
            video.save
          end
        end
      end

    end; end
  end
end
