require 'yaml'
require 'tmpdir'
require 'active_record'
require 'active_support/inflector'
require 'bcrypt' # required by various models/modules
require 'logger'
require 'pg'
require './lib/util/redis_server.rb'

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
    attr_accessor :run_env,:logger, :root_dir, :model_path, :test_path, :seed_path, :lib_path, :db_path, :tmp_path, :message_path

    def boot_all(app_root_dir = File::join(File::dirname(__FILE__),'..'))
      LT::setup_environment(app_root_dir)
      LT::init_logger
      LT::boot_db(File::join(LT::db_path, 'config.yml'))
      LT::load_all_models
      LT::boot_redis(File::join(LT::db_path, 'redis.yml'))
      LT::logger.info("Core-app booted")
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
      LT::tmp_path = Dir::tmpdir

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
    def boot_db(config_file)
      # Connect to DB
      begin
        boot_ar_config(config_file)
        dbconfig = YAML::load(File.open(config_file))
        # TODO:  Need better error message of LT::run_env is not defined; occurred multiple times in testing
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
      self.logger = Logger.new(File::join(LT::tmp_path,'lt_application.log'), 'daily')
      self.logger.formatter = Logger::Formatter.new
      self.logger.info("LT::logger initialized")
    end
  end # class << self (LT)

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
    # create a user in a section
    module Students class << self
      def create_joe_smith_scenario
        scenario = {
          :student=>{
            :username=>"joesmith@foo.com",
            :password=>"pass",
            :first_name=>"Joe",
            :last_name=>"Smith",
            :email=> "joesmith@foo.com",
            :student=>{}
          },
          :student2=>{
            :username=>"bob@foo.com",
            :password=>"pass2",
            :first_name=>"Bob",
            :last_name=>"Newhart",
            :email=> "bobnewhard@foo.com",
            :student=>{}
          },
          :section=>{
            :name=>"CompSci Period 2",
            :section_code=>"Comp Sci Room 2"
          },
          :teacher=>{
            :username=>"janedoe@bar.com",
            :password=>"pass",
            :first_name=>"Jane",
            :last_name=>"Doe",
            :email=> "janedoe@bar.com",
            :staff_member=>{
              :staff_member_type=>'Teacher'
            }
          },
          :sites=>[{
            :display_name=>"Khan Academy",
            :url=>'http://www.khanacademy.com'
            }
          ],
          :pages=>[{
            :display_name=>"Converting Decimals to Fractions 2 (ex 1)",
            :url=>'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-decimals-to-fractions-2-ex-1',
            # this field is not part of the model - used to help seed below
            :site_url=>'http://www.khanacademy.com'
            },
            {
            :display_name=>"Converting a fraction to a repeating decimal",
            :url=>'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-a-fraction-to-a-repeating-decimal',
            :site_url=>'http://www.khanacademy.com'
            }
          ],
          :site_visits=>[{
            # this field is not part of the model - used to help seed below
            :url=>'http://www.khanacademy.com', 
            :date_visited=>Time.now-1.day,
            :time_active=>42.minutes.to_i
            },
            {
            :url=>'http://www.khanacademy.com',
            :date_visited=>Time.now-2.days,
            :time_active=>33.minutes.to_i
            }
          ],
          :page_visits=>[{
            # this field is not part of the model - used to help seed below
            :url=>'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-decimals-to-fractions-2-ex-1',
            :date_visited=>Time.now-1.day,
            :time_active=>15.minutes.to_i
            },
            {
            :url=>'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-decimals-to-fractions-2-ex-1',
            :date_visited=>Time.now-2.days,
            :time_active=>12.minutes.to_i
            },
            {
            :url=>'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-a-fraction-to-a-repeating-decimal',
            :date_visited=>Time.now-2.days,
            :time_active=>7.minutes.to_i
            }
          ]
        }
        student = User.create_user(scenario[:student])[:user].student
        student2 = User.create_user(scenario[:student2])[:user].student
        teacher = User.create_user(scenario[:teacher])[:user].staff_member
        section = Section.create(scenario[:section])
        student.add_to_section(section)
        student2.add_to_section(section)
        teacher.add_to_section(section)
        # we add all user activity data to two students
        # this is to make sure that we can find data associated with only student at a time
        [student, student2].each do |student|
          # create site records, and associated site_visited records
          # we have to tie sites_visited to sites
          # we have to tie sites_visited to users
          scenario[:sites].each do |site|
            site = site.dup
            s = Site.find_or_create_by(site)
            scenario[:site_visits].each do |site_visit|
              site_visit = site_visit.dup
              if s.url == site_visit[:url] then
                site_visit.delete(:url)
                sv = SiteVisit.create(site_visit)
                s.site_visits << sv
                student.site_visits << sv
              end
            end
          end
          # create page records, and associated page_visited records
          # we have to tie pages to sites as well as pages_visited
          # we have to tie pages_visited to users
          scenario[:pages].each do |page|
            page = page.dup
            s = Site.find_by_url(page[:site_url])
            page.delete(:site_url)
            p = Page.find_or_create_by(page)
            s.pages << p
            scenario[:page_visits].each do |page_visit|
              page_visit = page_visit.dup
              if p.url == page_visit[:url] then
                page_visit.delete(:url)
                pv = PageVisit.create(page_visit)
                p.page_visits << pv
                student.page_visits << pv
              end
            end
          end
        end #[student, student2].each do |student|
        scenario
      end # create_joe_smith_seed
    end; end
  end # Seeds module

  module Janitor
    class << self
    end # class << self
  end # Janitor module
end # LT module
