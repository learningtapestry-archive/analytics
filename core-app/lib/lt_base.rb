require 'yaml'
require 'tmpdir'
require 'active_record'
require 'active_support'
require 'active_support/inflector'
require 'action_view'
require 'bcrypt' # required by various models/modules
require 'log4r'
require 'log4r/yamlconfigurator'
require 'pg'
require './lib/util/redis_server.rb'
require './lib/util/scenarios.rb'

module LT
  class BaseException < StandardError
    def initialize(message="Undefined LT Error Message")
      if LT::logger.respond_to?(:error) then
        LT::logger.error(message)
      else
        `echo Logging failure in LT BaseException at #{Time.now} >> /tmp/lt-log-failure.txt`
      end
      super(message)
    end
  end
  class ParameterMissing < BaseException;end
  class InvalidParameter < BaseException;end
  class Critical < BaseException;end
  class LoginError < BaseException;end
  class UserNotFound < LoginError;end
  class PasswordInvalid < LoginError;end
  class FileNotFound < BaseException;end
  class PathNotFound < BaseException;end
  class ModelNotFound < BaseException;end
  class InvalidFileFormat < BaseException;end

  module Constants
    SERVICES_YOUTUBE = 'youtube'
  end

  class << self
    def env?(type)
      (self.run_env == (type && ENV['RAILS_ENV'] = type))    
    end
    def testing?
      # we are only in a testing environment if RAILS_ENV and run_env agree on it
      env?('test')
    end
    def development?
      # we are only in a development environment if RAILS_ENV and run_env agree on it
      env?('development')
    end
    def production?
      env?('production')
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
    attr_accessor :run_env,:logger, :root_dir, :model_path, 
      :test_path, :seed_path, :lib_path, :db_path, :tmp_path, :log_path,
      :message_path, :janitor_path, :web_root_path, :web_asset_path, :partner_lib_path

    def boot_all(app_root_dir = File::join(File::dirname(__FILE__),'..'))
      LT::setup_environment(app_root_dir)
      LT::init_logger
      LT::boot_db(File::join(LT::db_path, 'config.yml'))
      LT::load_all_models
      LT::require_env_specific_files
      LT::boot_redis(File::join(LT::db_path, 'redis.yml'))
      LT::logger.info("Core-app booted (mode: #{LT::run_env})")
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
      LT::janitor_path = File::expand_path(File::join(LT::lib_path,'/janitors'))
      LT::web_root_path = File::expand_path(File::join(LT::root_dir, '/web-public'))
      LT::web_asset_path = File::expand_path(File::join(LT::web_root_path, '/assets'))
      LT::partner_lib_path = File::expand_path(File::join(LT::root_dir, '/partner-lib'))
      local_tmp = File::expand_path(File::join(LT::root_dir, '/tmp'))
      LT::tmp_path = File::exists?(local_tmp) ? local_tmp : Dir::tmpdir
      local_log = File::expand_path(File::join(LT::root_dir, '/log'))
      LT::log_path = File::exists?(local_log) ? local_log : LT::tmp_path
      LT::message_path = File::expand_path(File::join(LT::root_dir, '/log/messages'))
      unless File.directory?(LT::message_path)
        FileUtils.mkdir_p(LT::message_path)
      end
    end
    def load_all_models
      models = Dir::glob(File::join(LT::model_path, '*.rb'))
      models.each do |file| 
        full_file =  File::join(LT::model_path, File::basename(file))
        require full_file
      end
    end
    def require_env_specific_files
      # Note to future self: do not create production specific requirements
      if LT::development? then
        require 'pry'
        require 'pry-stack_explorer'
      end
    end

    def boot_db(config_file)
      # Connect to DB
      begin
        boot_ar_config(config_file)
        dbconfig = YAML::load(File.open(config_file))
        ActiveRecord::Base.establish_connection(dbconfig[LT::run_env])
      rescue Exception => e
        LT::logger.error("Cannot connect to Postgres, connect string: #{dbconfig[LT::run_env]}, error: #{e.message}")
        raise e
      end
    end
    def boot_ar_config(config_file)
      # http://stackoverflow.com/questions/20361428/rails-i18n-validation-deprecation-warning
      # SM: Don't really know what this means - hopefully doesn't matter
      I18n.config.enforce_available_locales = true
      ActiveRecord::Base.configurations = ActiveRecord::Tasks::DatabaseTasks.database_configuration = YAML::load_file(config_file)
      ActiveRecord::Tasks::DatabaseTasks.db_dir = LT::db_path
      ActiveRecord::Tasks::DatabaseTasks.env    = LT::run_env
      #If you need to customize AR model pluralization do it here
      ActiveSupport::Inflector.inflections do |inflect|
        #inflect.irregular 'weird_singular_model_thingy', 'wierd_plural_model_thingies'
      end
    end
    def boot_redis(config_file)
      LT::RedisServer::boot_redis(config_file)

    end
    def get_db_name
      return ActiveRecord::Base.connection_config[:database]
    end
    def ping_db
      begin
        return ActiveRecord::Base.connection.active?
      rescue
        return false
      end
      return false
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

    # will initialize the logger
    def init_logger
      # prevent us from re-initializing the logger if it's already created
      return if self.logger.kind_of?(Logger)

      # Attempt to load configuration file, if doesn't exist, use standard output
      log4r_config_file = File.expand_path(LT::db_path + "/log4r.yml")
      if File.exist?(log4r_config_file) then
        log4r_config = YAML.load(ERB.new(File.read(log4r_config_file)).result)
        Log4r::YamlConfigurator.decode_yaml(log4r_config['log4r_config'])
        self.logger = Log4r::Logger[LT::run_env]
      else
        self.logger = Log4r::Logger.new(LT::run_env)
        self.logger.level = Log4r::DEBUG
        self.logger.add Log4r::Outputter.stdout
        self.logger.warn "Log4r configuration file not found, attempted: #{LT::db_path + "/log4r.yml"}"
        self.logger.info "Log4r outputting to stdout with DEBUG level."
      end
    end
  end # class << self (LT)
  # postgres specific utilities
  module PG class << self
    def begin_transaction
      ActiveRecord::Base.connection.execute("BEGIN")
    end
    def commit_transaction
      ActiveRecord::Base.connection.execute("COMMIT")
    end
    def rollback_transaction
      ActiveRecord::Base.connection.execute("ROLLBACK")
    end
  end; end #PG
  module Seeds
    SEED_FILES = '.seeds.rb'
    class << self
      def seed!
        run_env = LT::run_env
        # this loads all the seeds in the root (common seeds)
        LT::Seeds::load_seeds
        # This runs all seeds for environment, eg "test"
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
  end # Seeds

  module Janitor
    class << self
    end # class << self
  end # Janitor module
end # LT module
