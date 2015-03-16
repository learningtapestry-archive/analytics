class Video < ActiveRecord::Base
  has_many :video_views
  belongs_to :site

  # we override AR to first convert URLs to their canonical form
  def self.find_or_create_by_url(url)
    video = self.find_by_url(url)
    if video.nil?
      puts "video is nil"
      video = Video.new
      video.url = url
      video.save
    end

    video
  end

end
