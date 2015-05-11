$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'lt/tasks'

Rake::Task['lt:boot'].overwrite do
  LT::Environment.boot_all(File::dirname(__FILE__))
end

namespace :lt do
  namespace :janitors do
    desc 'Process page visits workload from Redis to data tables'
    task process_redis_page_messages: [:import_raw_messages, :extract_page_visits] do
      LT.env.logger.info('process_redis_page_messages')
    end

    desc 'Process video views workload from Redis to data tables'
    task process_redis_video_messages: [:import_raw_messages, :extract_video_views] do
      LT.env.logger.info('process_redis_video_messages')
    end

    desc 'Convert Redis queue to raw_messages table'
    task import_raw_messages: :'lt:boot' do
      require 'janitors/raw_message_importer'

      Analytics::Janitors::RawMessageImporter.new(LT.env.logger, 2000).import
    end

    desc 'Extract page views from raw_messages'
    task extract_page_visits: :'lt:boot' do
      require 'janitors/visit_extractor'

      Analytics::Janitors::VisitExtractor.new(LT.env.logger, 2000).extract
    end
    desc "Convert raw_messages to video_views"
    task extract_video_views: :'lt:boot' do
      require 'janitors/visualization_extractor'

      Analytics::Janitors::VisualizationExtractor.new(LT.env.logger, 2000).extract
    end

    desc "Fill YouTube Information"
    task fill_video_youtube_information: :'lt:boot' do
      require 'janitors/video_metadata_extractor'

      config = LT.env.load_optional_config('youtube.yml')
      Analytics::Janitors::VideoMetadataExtractor.new(LT.env.logger, 2000, config).extract
    end
  end

  namespace :utility do
    desc "Loads a single CSV file into the corresponding database table"
    task :load_file, [:csvfile] do |t,args|
      Rake::Task[:'lt:boot'].invoke
      require 'utils/csv_database_loader'
      Analytics::Utils::CsvDatabaseLoader.load_file(args[:csvfile])
    end

    desc "Loads all CSV files within a path into the corresponding database tables"
    task :load_dir, [:csvpath] do |t,args|
      Rake::Task[:'lt:boot'].invoke
      require 'utils/csv_database_loader'
      Analytics::Utils::CsvDatabaseLoader.load_directory(args[:csvpath])
    end
  end
end

#
# Some shortcuts to core tasks
#
task :full_tests do
  Rake::Task[:'lt:full_tests'].invoke
end

task :tests do
  Rake::Task[:'lt:tests'].invoke
end

task :console do
  Rake::Task[:'lt:console'].invoke
end
