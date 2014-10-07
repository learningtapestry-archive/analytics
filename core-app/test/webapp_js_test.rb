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

class WebAppJSTest < Minitest::Test
  include Rack::Test::Methods
  include Capybara::DSL

  def save_load_screenshot(page)
    file_screenshot = File::expand_path(File::join(LT::tmp_path, "collector_errors.png"))
    page.save_screenshot(file_screenshot)
    `google-chrome #{file_screenshot}`
    file_screenshot
  end

  # this method is somewhat indirect
  # It calls an html test page via capybara/poltergeist/phantomjs
  # This html page runs a series of qUnit javascript tests
  # The results of the qUnit test runs are loaded by this test method
  # Those results are in xml, which this test method parses and looks for failing tests.
  # If it finds failing tests it will fail the test run w/a message.
  # It will also save a screenshot of the failing qUnit test results page (to LT::tmp_dir)
  # It will try to open that screenshot in chrome
  def test_js_collector
    # set up data to make collector test work
    joe_smith_username=CGI::escape(@joe_smith[:username])
    acme_org_api_key = CGI::escape(@acme_org[:org_api_key])
    collector_test_url = "/assets/tests/js-collector-test.html?username=#{joe_smith_username}&org_api_key=#{acme_org_api_key}"
    collector_js_url = "/api/v1/collector.js?username=#{joe_smith_username}&org_api_key=#{acme_org_api_key}"
    # verify that we can get to the collector.js file itself without errors
    get(collector_js_url)
    assert_equal 200, last_response.status
    # after confirming that the collector.js file is obtainable
    # we can make the full headless browser call to the test file
    visit(collector_test_url)
    i = 0
    # wait for qunit tests to execute in phantomjs
    # we are waiting for this element to appear on the page: <div id="qunit">
    sleep 0.1
    html = Nokogiri::HTML.parse(page.html)
    while !html.at_css('div#qunit').child do 
      # wait up to 2 seconds for page to fully load (including javascript)
      i+=1
      if i > 20 then
        assert false, "Failed to find QUnit test results before timeout." 
        break
      end
      sleep 0.1
      html = Nokogiri.parse(page.html)
    end
    # loop through xml test case data and make sure there were no errors
    resultsXML = Nokogiri::XML(html.css("span#xmlTestResults").inner_html.to_s)
    resultsXML.css("testsuites>testsuite>testcase").each do |suite|
      num_failures = suite.attribute("failures").to_s
      testcase_name = suite.attribute("name").to_s
      test_failed = false
      # take a screenshot of qunit results, if there are errors
      if num_failures!="0" then
        file_screenshot = save_load_screenshot(page)
      end
      fail_message = "QUnit Javascript testcase named \"#{testcase_name}\" had #{num_failures} failures.\n"\
       "Screenshot of testrun failures at #{file_screenshot}.\n"\
       "Google Chrome should now have a window open to this file."
      assert_equal "0", num_failures, fail_message
    end
    # Sanity: make sure that we have run some tests in this method
    assert self.assertions >= 2, "An unknown failure has caused JS tests to not run. Results XML:\n"\
      "#{resultsXML.to_s}"

    # validate that window.ltG.fSendMsg sends a message that is received by redis
    time_on_site = '10M8S'
    page_title = 'Foobar title'
    page_url = 'http://foo.bar.com/foobity'
    pageViewScript = "window.ltG.fSendPageView('#{page_url}','#{page_title}','#{time_on_site}');"
    LT::RedisServer.api_key_set('abc123','does not matter')
    page.execute_script(pageViewScript)
    # we need to wait for the ajax call to complete
    sleep 0.1
    message = LT::RedisServer.raw_message_pop
    refute_nil message, "No Redis message received from Ajax call via assert api."
    message = JSON.parse(message)
    assert_equal time_on_site, message["action"]["time"]
    assert_equal RawMessage::Verbs::VIEWED, message["verb"]
    assert_equal page_title, message["page_title"]
    assert_equal page_url, message["url"]
  end

  @first_run
  def before_suite
    if !@first_run
      LT::RedisServer::clear_all_test_lists
      DatabaseCleaner[:active_record].strategy = :transaction
      DatabaseCleaner[:redis].strategy = :truncation
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
      # To use the debugger add "page.driver.debug" in this file, *before* the JS code call you want to debug
      # When you run your test, you'll get a new window in chrome. Click the second link on that page
      # This is your code - select the JS file from the upper left pull-down
      # Set a breakpoint where you want to intercept the code
      # Press enter in the terminal console where your test is running
      # You'll see the code in the browser stopped on the line you breakpointed.
      # more info here: http://www.jonathanleighton.com/articles/2012/poltergeist-0-6-0/
    end
    @first_run = true
  end

  def setup
    before_suite
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
    LT::Seeds::seed!
    @scenario = LT::Scenarios::Students::create_joe_smith_scenario
    @joe_smith = @scenario[:student]
    @jane_doe = @scenario[:teacher]
    @section = @scenario[:section]
    @page_visits = @scenario[:page_visits]
    @site_visits = @scenario[:site_visits]
    @sites = @scenario[:sites]
    @pages = @scenario[:pages]
    @acme_org = @scenario[:organizations].first
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
  def app
    LT::WebApp
  end
end