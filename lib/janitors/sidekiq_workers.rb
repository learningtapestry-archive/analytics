require 'sidekiq'

class RawMessageImporter
  include Sidekiq::Worker

  def perform
    `bundle exec rake lt:janitors:import_raw_messages`
  end
end

class PageVisitExtractor
  include Sidekiq::Worker

  def perform
    `bundle exec rake lt:janitors:extract_page_visits`
  end
end

class VideoViewExtractor
  include Sidekiq::Worker

  def perform
    `bundle exec rake lt:janitors:extract_video_views`
  end
end
