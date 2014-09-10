gem "minitest"
require 'minitest/autorun'
require 'rack/test'
require 'fileutils'
require 'tempfile'
require 'debugger'
#require 'chronic'
#require 'timecop'
require 'uri'
require 'database_cleaner'

require File.expand_path('./lib/webapp.rb')

class WebAppTest < Minitest::Test
  include Rack::Test::Methods
  def test_webapp_root
    get "/"
    assert_equal 200, last_response.status, last_response.body
    assert last_response.body.match(/Hello world/)
  end
  def test_dashboard
    get "/dashboard"
    assert_equal 200, last_response.status, last_response.body
    assert last_response.body.match(/Your Dashboard/)
  end


  def self.before_suite
    DatabaseCleaner.strategy = :transaction
  end
  def setup
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
    ## TODO: Question should seed! go up into before_suite to reduce reload time?
    # re-seed data for each test
    #LT::WebApp::Seeds::seed!
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end
  def app
    LT::WebApp
  end
end