require 'open-uri'
require 'json'
require 'nokogiri'

module LT
  module Janitors
    module HttpMetadataExtractor class << self

      def fill_youtube_info
        Video.where("title IS NULL AND service_id = '#{LT::Constants::SERVICES_YOUTUBE}'").each do | video |
          document = Nokogiri::XML(open("http://gdata.youtube.com/feeds/api/videos/#{video.external_id}"))

          if document
            document.remove_namespaces!
            begin
              video.service_id = LT::Constants::SERVICES_YOUTUBE
              video.title = document.xpath('/entry/title')[0].text.strip
              video.description = document.xpath('/entry/group/description').text
              video_seconds = document.xpath('//duration')[0].attributes['seconds'].value.to_i
              video.video_length = Time.at(video_seconds).utc.strftime('%H:%M:%S')
              video.views = document.xpath('/entry/statistics')[0].attributes['viewCount'].value.to_i
              video.publisher = document.xpath('/entry/author/name').text
              video.category = document.xpath('/entry/group/category').text
              video.rating = document.xpath('/entry/rating')[0].attributes['average'].value.to_f
              video.raters = document.xpath('/entry/rating')[0].attributes['numRaters'].value.to_i
              video.published_on = DateTime.parse(document.xpath('/entry/published')[0].text)
              video.updated_on = DateTime.parse(document.xpath('/entry/updated')[0].text)
              video.save
              rescue Exception => e
                LT::logger.warn "Could not parse YouTube video #{video.url}", e
            end
          else
            LT::logger.warn "YouTube did not return XML as expected during metadata extraction #{video.url}"
          end
        end
      end

    end; end
  end
end

=begin
  create_table "videos", force: true do |t|
    t.text     "service_id"
    t.text     "external_id"
    t.text     "url"
    t.text     "title"
    t.text     "description"
    t.text     "publisher"
    t.text     "category"
    t.string   "video_length", limit: nil
    t.integer  "views",        limit: 8
    t.float    "rating"
    t.integer  "raters",       limit: 8
    t.datetime "published_on"
    t.datetime "updated_on"
  end
=end