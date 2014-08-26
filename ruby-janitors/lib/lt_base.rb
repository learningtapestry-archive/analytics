require 'yaml'
require 'active_record'
require 'active_support/inflector' # required by module Seedlib

module LT
  class BaseException < Exception;end;
  class Critical < BaseException;end;
  class << self
    def testing?
      # we are only in a testing environment if RAILS_ENV and run_env agree on it
      (self.run_env == ('test' && ENV['RAILS_ENV'] = 'test'))
    end
    # raise an exception if we are not in testing mode
    def testing!(msg="Expected to be in testing env, but was not.")
      raise LT::Critical.new(msg) if !LT::testing?
    end
    # run_env holds running environment: production|staging|test|development
    attr_accessor :run_env
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
      # TODO These folders need to be offloaded into module Janitor somehow
      LT::Janitor::root_dir = File::expand_path(app_root_dir)
      LT::Janitor::model_path = File::expand_path(File::join(LT::Janitor::root_dir, '/lib/model'))
      LT::Janitor::lib_path = File::expand_path(File::join(LT::Janitor::root_dir, '/lib'))
      LT::Janitor::test_path = File::expand_path(File::join(LT::Janitor::root_dir, '/test'))
      LT::Janitor::seed_path = File::expand_path(File::join(LT::Janitor::root_dir, '/db/seeds'))    
    end
    def load_all_models
      models = Dir::glob(File::join(LT::Janitor::model_path, '*.rb'))
      models.each do |file| 
        full_file =  File::join(LT::Janitor::model_path, File::basename(file))
        require full_file
      end
    end
    def boot_db(config_file)
      # Connect to DB
      begin
        dbconfig = YAML::load(File.open(config_file))
        ActiveRecord::Base.establish_connection(dbconfig[LT::run_env])
      rescue Exception => e
        LT::Janitor::logger.error("Cannot connect to Postgres, connect string: #{dbconfig['development']}, error: #{e.message}")
        # SM: Re-raising an error is better than eating it, IMO, so I'm removing the abort
        raise e
        #abort()
      end
    end
    def run_tests(test_path)
    	test_file_glob = File::expand_path(File::join(test_path, '*_test.rb'))
      testfiles = Dir::glob(test_file_glob)
      testfiles.each do |testfile| 
        full_testfile =  File::join(test_path, File::basename(testfile))
        run_test(full_testfile, test_path)
      end
    end
    # will test a single file in test folder
    # test file must self-run when "required"
    # TODO: Fix Rake which calls LT::Janitor for this function with a different signature
    def run_test(testfile, test_path)
      LT::testing!
      # add testing path if it is missing from file
      if testfile == File::basename(testfile) then
        testfile = File::join(test_path, File::basename(testfile))
      end
      require testfile
    end # run_test
  end # class << self (LT)

	# Module mix-in to enable seeding in seed files
	# Usage in seed file (seed files are named *.seeds.rb)
	#   require './lt_base.rb'
	#   include LT::Seedlib
	#   seed do # block of seeding code; end
	# Nb. You can override the filename for seed with:
	#   seed(:file=>"filename...")
	# Usage to run seeds
	#   Call Seedlib::seed!(name) # to run name
	#   e.g. if file was "./db/seeds/raw_messages.seeds.rb"
	#        name is "RawMessage"
	#        so seed: Seedlib::seed!("RawMessage")
	module Seedlib
	  @seed_blocks = {}
	  class << self
	    attr_accessor :seed_blocks
	    def seed(opts={},block)
	      id = opts[:id]
	      id = File::basename(id).match(/(.*?)\./)[1].classify
	      Seedlib::seed_blocks[id] = {:block => block}
	    end
	    def seed_all!
	      Seedlib::seed_blocks.each do |key,val|
	        puts key.inspect
	        val[:block].call
	      end
	    end
	    def seed!(id)
	      Seedlib::seed_blocks[id][:block].call
	    end
	  end
	  def seed(opts = {}, &block)
	    # get the filename where the block came from (warning: voodoo)
	    file = eval("__FILE__", block.binding)
	    file = opts[:file] if opts[:file]
	    Seedlib::seed({:id =>file},block)
	  end
	end


  module Janitor
    class << self
      # root_dir holds application root (where this Rake file is located)
      # model_path holds the folder where our models are stored
      # test_path holds folder where the tests are stored
      attr_accessor :logger, :root_dir, :model_path, :test_path, :seed_path, :lib_path
      # will test all files in test folder: *_test.rb
      def init_logger
        self.logger = Logger.new($stdout)
      end
      def run_tests
      	LT::run_tests(LT::Janitor::test_path)
        LT::Janitor::logger.info('Tests complete')
      end
    end # class << self

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
          LT::Janitor::Seeds::load_seeds
          # This will run all seeds for environment, eg "test"
          env_seeds = File::join('./',run_env)
          LT::Janitor::Seeds::load_seeds(env_seeds)
          seed_all!
        end
	      # This looks in the path provided for files globbing SEED_FILES, 
	      # "requiring" each one.
	      # The assumption is that each file will know how to load itself
	      def load_seeds(path = './')
	        fullpath = File::expand_path(File::join(LT::Janitor::seed_path,path))
	        seedfiles=Dir::glob(File::join(fullpath,'*'+SEED_FILES))
	        seedfiles.each do |seedfile|
	          require File::expand_path(seedfile)
	        end
	      end # load_seeds
      end #class << self
    end # Seeds module
  end # Janitor module
end # LT module
