require 'yaml'
require 'active_record'
require 'active_support/inflector' # required by module Seedlib

module LT
  # TODO:  Namespace this Exceptions
  class BaseException < Exception;end;
  class ParameterMissing < BaseException;end
  class InvalidParameter < BaseException;end
  class Critical < BaseException;end;
  class LoginError < BaseException;end;
  class UserNotFound < LoginError;end;
  class PasswordInvalid < LoginError;end;


  class << self
    def testing?
      # we are only in a testing environment if RAILS_ENV and run_env agree on it
      (self.run_env == ('test' && ENV['RAILS_ENV'] = 'test'))
    end
    def development?
      # we are only in a development environment if RAILS_ENV and run_env agree on it
      (self.run_env == ('development' && ENV['RAILS_ENV'] = 'development'))
    end
    # raise an exception if we are not in testing mode
    def testing!(msg="Expected to be in testing env, but was not.")
      raise LT::Critical.new(msg) if !LT::testing?
    end
    def development!(msg="Expected to be in testing env, but was not.")
      raise LT::Critical.new(msg) if !LT::development?
    end
    # run_env holds running environment: production|staging|test|development
    # root_dir holds application root (where this Rake file is located)
    # model_path holds the folder where our models are stored
    # test_path holds folder where the tests are stored
    attr_accessor :run_env,:logger, :root_dir, :model_path, :test_path, :seed_path, :lib_path, :db_path

    def boot_all(app_root_dir = File::join(File::dirname(__FILE__),'..'))
      LT::init_logger
      LT::setup_environment(app_root_dir)
      LT::boot_db(File::join(LT::db_path, 'config.yml'))
      LT::load_all_models
      LT::boot_redis(File::join(LT::db_path, 'redis.yml'))
    end

    # app_root_dir is the path to the root of the application being booted
    def setup_environment(app_root_dir)
      # null out empty string env vars
      if ENV['RAILS_ENV'] && ENV['RAILS_ENV'].empty? then
        ENV['RAILS_ENV'] = nil
      end
      if ENV['RACK_ENV'] && ENV['RACK_ENV'].empty? then
        ENV['RACK_ENV'] = nil
      end
      LT::run_env = ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
      ENV['RAILS_ENV'] = LT::run_env
      Rails.env = LT::run_env if defined? Rails
      LT::root_dir = File::expand_path(app_root_dir)
      LT::model_path = File::expand_path(File::join(LT::root_dir, '/lib/model'))
      LT::lib_path = File::expand_path(File::join(LT::root_dir, '/lib'))
      LT::test_path = File::expand_path(File::join(LT::root_dir, '/test'))
      LT::db_path = File::expand_path(File::join(LT::root_dir, '/db'))      
      LT::seed_path = File::expand_path(File::join(LT::root_dir, '/db/seeds'))
    end
    def load_all_models
      models = Dir::glob(File::join(LT::model_path, '*.rb'))
      models.each do |file| 
        full_file =  File::join(LT::model_path, File::basename(file))
        require full_file
      end
    end
    def boot_db(config_file)
      # Connect to DB
      begin
        dbconfig = YAML::load(File.open(config_file))
        # TODO:  Need better error message of LT::run_env is not defined; occurred multiple times in testing
        ActiveRecord::Base.establish_connection(dbconfig[LT::run_env])
      rescue Exception => e
        LT::logger.error("Cannot connect to Postgres, connect string: #{dbconfig[LT::run_env]}, error: #{e.message}")
        raise e
      end
    end
    def boot_redis(config_file)
      LT::RedisServer::boot_redis(config_file)
    end
    def get_db_name(config_file)
      # TODO:  Refactor to utilize current AR connection
      dbconfig = YAML::load(File.open(config_file))
      return dbconfig[LT::run_env]["database"]
    end
    def run_tests(test_path = LT::test_path)
    	test_file_glob = File::expand_path(File::join(test_path, '**/*_test.rb'))
      testfiles = Dir::glob(test_file_glob)
      testfiles.each do |testfile|
        run_test(testfile, test_path)
      end
    end
    # will test a single file in test folder
    # test file must self-run when "required"
    # TODO: Fix Rake which calls this function with a different signature
    def run_test(testfile, test_path)
      LT::testing!
      # add testing path if it is missing from file
      if testfile == File::basename(testfile) then
        testfile = File::join(test_path, File::basename(testfile))
      end
      #TODO: This should be load not require I think (for re-entrant code running)
      require testfile
    end # run_test

    # will test all files in test folder: *_test.rb
    def init_logger
      self.logger = Logger.new($stdout)
    end
  end # class << self (LT)

  module Seeds
    SEED_FILES = '.seeds.rb'
    class << self
      # execute all the seeds loaded to date
      def seed_all!
        LT::Seedlib::seed_all!
      end
      # execute only seed specified
      # Nb. id will generally be the "classify" name of the seed file
      # e.g., raw_messages.seeds.rb will have id="RawMessage"
      def seed!(id)
        LT::Seedlib::seed!(id)
      end
      def seed!
        run_env = LT::run_env
        LT::Seeds::load_seeds
        # This will run all seeds for environment, eg "test"
        env_seeds = File::join('./',run_env)
        LT::Seeds::load_seeds(env_seeds)
      end
      # This looks in the path provided for files globbing SEED_FILES, 
      # "requiring" each one.
      # The assumption is that each file will know how to load itself
      def load_seeds(path = './')
        fullpath = File::expand_path(File::join(LT::seed_path,path))
        seedfiles = Dir::glob(File::join(fullpath,'*'+SEED_FILES))
        seedfiles.each do |seedfile|
          load_seed(seedfile)           
        end
      end # load_seeds
      def load_seed(seedfile)
        load File::expand_path(seedfile)
      end
    end #class << self
  end # Seeds module

  module Janitor
    class << self
    end # class << self
  end # Janitor module
end # LT module
