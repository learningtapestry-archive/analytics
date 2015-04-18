require 'uri'

class Video < ActiveRecord::Base
  has_many :video_views
  belongs_to :site

  # we override AR to first convert URLs to their canonical form
  def self.find_or_create_by_url(url)
    video = self.find_by_url(url)
    if video.nil?
      video = Video.new
      video.url = url
      uri = URI(url)
      if uri.host.include?('youtube')
        video.service_id = 'youtube'
        uri.query.split('&').each do |param|
          if param.split('=').size == 2 and param.split('=')[0] == 'v'
            video.external_id = param.split('=')[1]
          end
        end
      end
      video.save
    end

    video
  end
end
