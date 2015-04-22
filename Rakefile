$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'lt/tasks'

Rake::Task['lt:boot'].overwrite do
  LT::Environment.boot_all(File::dirname(__FILE__))
end

namespace :lt do
  namespace :janitors do
    desc "Process full workload from Redis to data tables"
    task :process_redis_messages => [:redis_to_raw_messages, :raw_messages_to_page_visits] do
      LT.environment.logger.info("process_redis_analytics completed")
    end

    desc "Convert Redis queue to raw_messages table"
    task :redis_to_raw_messages do
      Rake::Task[:'lt:boot'].invoke
      require 'janitors/redis_postgres_extract'
      Analytics::Janitors::RedisPostgresExtract.redis_to_raw_messages
    end
    desc "Convert raw_messages to page_views"
    task :raw_messages_to_page_visits do
      Rake::Task[:'lt:boot'].invoke
      require 'janitors/redis_postgres_extract'
      Analytics::Janitors::RawMessagesExtract.raw_messages_to_page_visits
    end
    desc "Convert raw_messages to video_views"
    task :raw_messages_to_video_views do
      Rake::Task[:'lt:boot'].invoke
      require 'janitors/redis_postgres_extract'
      Analytics::Janitors::RawMessagesExtract.raw_messages_to_video_visits
    end
    desc "Fill YouTube Information"
    task :fill_video_youtube_information do
      Rake::Task[:'lt:boot'].invoke
      require 'janitors/web_extractor'
      Analytics::Janitors::WebExtractor.fill_youtube_info
    end

    desc "Extract Learning Registry data to raw documents table from http://sandbox.learningregistry.org"
    task :extract_meta_data do # TODO: rename this rake task name.
      Rake::Task[:'lt:boot'].invoke
      require 'janitors/learning_registry_extract'
      Analytics::Janitors::LearningRegistryExtract.retrieve({'node' => 'http://sandbox.learningregistry.org'})
    end
  end # namespace :janitors

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
