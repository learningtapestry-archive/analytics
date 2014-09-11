gem "minitest"
require 'minitest/autorun'
require 'rack/test'
#require 'fileutils'
#require 'tempfile'
#require 'debugger'
#require 'nokogiri'
#require 'chronic'
#require 'timecop'
#require 'uri'
require 'database_cleaner'

require File.expand_path('./lib/webapp.rb')

class WebAppTest < Minitest::Test
  include Rack::Test::Methods
  def test_homepage
    get "/"
    assert_equal 200, last_response.status, last_response.body
    html = Nokogiri.parse(last_response.body)
    result = html.css('body>h1').text
    assert_equal "Hello world", result
  end
  def test_dashboard
    get "/dashboard"
    assert_equal 200, last_response.status, last_response.body
    html = Nokogiri.parse(last_response.body)
    result = html.css('head>title').text
    assert_equal "Learntaculous - Your Dashboard", result

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