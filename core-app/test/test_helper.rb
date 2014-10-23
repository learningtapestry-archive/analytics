gem "minitest"
require 'minitest/autorun'
require 'rack/test'
require 'nokogiri'
require 'debugger'
require 'database_cleaner'
require 'capybara'
require 'capybara/poltergeist'
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
  def setup
    super
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:redis].strategy = :truncation
    DatabaseCleaner[:redis, {connection: LT::RedisServer.connection_string}] 
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
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
  end
  def use_poltergeist
    Capybara.current_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
  end

  # To use the poltergeist javascript debugger add "page.driver.debug" 
  # in test file, *before* the JS code call you want to debug
  # When you run your test, you'll get a new window in chrome. 
  # Click the second link on that page
  # Chrome opens your code/page - select the JS file from the upper left pull-down
  # Set a breakpoint where you want to intercept the code
  # Press enter in the terminal console where your test is running
  # You'll see the code in the browser stopped on the line you breakpointed.
  # more info here: http://www.jonathanleighton.com/articles/2012/poltergeist-0-6-0/
  def use_poltergeist_debug
    Capybara.current_driver = :poltergeist_debug
    Capybara.javascript_driver = :poltergeist_debug
  end

  def setup
    super
    Capybara.app = LT::WebApp
    # debug mode
    Capybara.register_driver :poltergeist_debug do |app|
      Capybara::Poltergeist::Driver.new(app, {:inspector => true, :timeout=>999})
    end
    # use_selenium
    # use poltergeist
    use_poltergeist_debug

  end
  def teardown
    super
    Capybara.reset_sessions!
    Capybara.current_session.driver.reset!
    Capybara.use_default_driver
  end
end # WebAppJSTestBase