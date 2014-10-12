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
end

# provides for transactional cleanup of activerecord activity
class LTDBTestBase < Minitest::Test
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

  def setup
    super
    Capybara.app = LT::WebApp
    Capybara.current_driver = :poltergeist
    Capybara.javascript_driver = :poltergeist
    # debug mode
    Capybara.register_driver :poltergeist_debug do |app|
      Capybara::Poltergeist::Driver.new(app, {:inspector => true, :timeout=>999})
    end
    # comment these lines out to use regular/non-debug webkit mode (probably faster)
    Capybara.current_driver = :poltergeist_debug
    Capybara.javascript_driver = :poltergeist_debug
    # To use the javascript debugger add "page.driver.debug" in this file, 
    # *before* the JS code call you want to debug
    # When you run your test, you'll get a new window in chrome. Click the second link on that page
    # This is your code - select the JS file from the upper left pull-down
    # Set a breakpoint where you want to intercept the code
    # Press enter in the terminal console where your test is running
    # You'll see the code in the browser stopped on the line you breakpointed.
    # more info here: http://www.jonathanleighton.com/articles/2012/poltergeist-0-6-0/
  end
  def teardown
    super
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end # WebAppJSTestBase