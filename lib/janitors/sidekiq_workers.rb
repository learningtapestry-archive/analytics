require 'sidekiq'
require 'sidekiq-cron'

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

class RawMessageDeleter
  include Sidekiq::Worker

  def perform
    `bundle exec rake lt:janitors:delete_raw_messages`
  end
end

Sidekiq::Cron::Job.create(name: 'Raw Message Importer', cron: '*/5 * * * *', class: 'RawMessageImporter')
Sidekiq::Cron::Job.create(name: 'Page Visit Extractor', cron: '*/5 * * * *', class: 'PageVisitExtractor')
Sidekiq::Cron::Job.create(name: 'Video View Extractor', cron: '*/5 * * * *', class: 'VideoViewExtractor')
Sidekiq::Cron::Job.create(name: 'Raw Message Deleter', cron: '*/5 * * * *', class: 'RawMessageDeleter')
