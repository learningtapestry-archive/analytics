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

  def test_js_collector
    visit('/assets/tests/js-collector-test.html')
    i = 0
    # wait for qunit tests to execute in phantomjs
    # we are waiting for this element to appear on the page: <div id="qunit">
    html = nil
    while true do 
      sleep 0.1
      html = Nokogiri.parse(page.html)
      break if html.at_css('div#qunit')
      # wait up to 2 seconds
      i+=1
      if i > 20 then
        assert false, "Failed to find QUnit test results before timeout." 
        break
      end
    end
    # loop through xml test case data and make sure there were no errors
    resultsXML = Nokogiri::XML(html.css("span#xmlTestResults").inner_html.to_s)
    resultsXML.css("testsuites>testsuite>testcase").each do |suite|
      num_failures = suite.attribute("failures").to_s
      testcase_name = suite.attribute("name").to_s
      test_failed = false
      # take a screenshot of qunit results, if there are errors
      if num_failures!="0" then
        file_screenshot = File::expand_path(File::join(LT::tmp_path, "collector_errors.png"))
        page.save_screenshot(file_screenshot)
        `google-chrome #{file_screenshot}`
      end
      fail_message = "QUnit Javascript testcase named \"#{testcase_name}\" had #{num_failures} failures.\n"\
       "Screenshot of testrun failures at #{file_screenshot}.\n"\
       "Google Chrome should now have a window open to this file."
      assert_equal "0", num_failures, fail_message
    end
  end

  @first_run
  def before_suite
    if !@first_run
      DatabaseCleaner[:active_record].strategy = :transaction
      DatabaseCleaner[:redis].strategy = :truncation
      Capybara.app = LT::WebApp
      Capybara.current_driver = :poltergeist
      Capybara.javascript_driver = :poltergeist
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