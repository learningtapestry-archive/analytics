gem "minitest"
require 'minitest/autorun'
require 'rack/test'
require 'nokogiri'
require 'debugger'
require 'database_cleaner'
require 'capybara'
require 'capybara/poltergeist'
require 'capybara/webkit'
require 'benchmark'

require File::join(LT::lib_path, 'webapp.rb')

class LTTestBase < Minitest::Test
  # method provides a block level way to temporarily set log level
  # to whatever level is desired, and automatically resets it
  # back to the original setting when finished
  def suspend_log_level(new_level = Log4r::FATAL)
    # set logging to critical to avoid reporting an error that is intended into the output
    orig_log_level = LT::logger.level
    LT::logger.level = new_level
    yield
    LT::logger.level = orig_log_level
  end
end

# provides for transactional cleanup of activerecord activity
class LTDBTestBase < LTTestBase
  def initialize(*opts)
    super(*opts)
    clean_using_default
  end

  # call this method to use truncation *once* for current test method
  # system will reset to using default strategy after the test method executes
  def clean_using_truncation
    @pg_strategy = :truncation
    @redis_strategy = :truncation
    setup_db_cleaner
  end

  def clean_using_transactions
    @pg_strategy = :transaction
    @redis_strategy = :truncation
    setup_db_cleaner
  end

  def clean_using_default
    clean_using_transactions
  end

  def setup_db_cleaner
    DatabaseCleaner.clean
    DatabaseCleaner[:active_record].strategy = @pg_strategy
    DatabaseCleaner[:redis].strategy = @redis_strategy
    DatabaseCleaner[:redis, {connection: LT::RedisServer.connection_string}] 
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
  end

  def setup
    super
    setup_db_cleaner
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
    clean_using_default
  end
end

# provides for Sinatra compatibility
class WebAppTestBase < LTDBTestBase
  require File::join(LT::lib_path, 'webapp.rb')
  include Rack::Test::Methods

  def app
    LT::WebApp
  end
end

# this test class is used to drive a headless phantomJS/webkit browser
# for full front-end testing, including javascript
class WebAppJSTestBase < WebAppTestBase
  include Capybara::DSL

  def use_selenium
    Capybara.default_driver = :selenium
    Capybara.reset_sessions!
    Capybara.current_session.driver.reset!
    Capybara.use_default_driver
  end
  def use_poltergeist
    Capybara.current_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    Capybara.default_driver = :poltergeist
    Capybara.reset_sessions!
    Capybara.current_session.driver.reset!
    Capybara.use_default_driver
  end

  # To use the poltergeist javascript debugger add "page.driver.debug" 
  # in test file, *before* the JS code call you want to debug
  # When you run your test, you'll get a new window in chrome. 
  # Click the second link on the page that is opened for you in chrome
  # That link opens your code/page - select the JS file from the upper left pull-down
  # Set a breakpoint where you want to intercept the code
  # Press enter in the terminal console where your test is running
  # You'll see the code in the browser stopped on the line you breakpointed.
  # more info here: http://www.jonathanleighton.com/articles/2012/poltergeist-0-6-0/
  def use_poltergeist_debug
    Capybara.current_driver = :poltergeist_debug
    Capybara.javascript_driver = :poltergeist_debug
    Capybara.default_driver = :poltergeist_debug
    Capybara.reset_sessions!
    Capybara.current_session.driver.reset!
    Capybara.use_default_driver
  end

  def use_webkit
    Capybara.javascript_driver = :webkit
    Capybara.current_driver = :webkit
    Capybara.default_driver = :webkit
    Capybara.reset_sessions!
    Capybara.current_session.driver.reset!
    Capybara.use_default_driver
  end


  def setup
    super
    Capybara.app = LT::WebApp
    # we create a new driver which is the debug mode for poltergeist
    Capybara.register_driver :poltergeist_debug do |app|
      Capybara::Poltergeist::Driver.new(app, {:inspector => true, :timeout=>999})
    end
    # use_selenium
    # use poltergeist
    # use web_kit
    use_poltergeist_debug

  end
  def teardown
    super
    Capybara.reset_sessions!
    Capybara.current_session.driver.reset!
    Capybara.use_default_driver
  end
end # WebAppJSTestBase