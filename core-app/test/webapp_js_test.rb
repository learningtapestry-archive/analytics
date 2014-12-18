require 'open-uri'
test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file


class WebAppJSTest < WebAppJSTestBase

  # PhantomJS outputs warnings to stdout that we don't want to see
  # particularly: we intentionally violate CORS and PhantomJS warns us of this
  def suppress_needless_msgs(output)
    silence_match = /XMLHttpRequest cannot load http:..[a-z0-9.:]+.test.html. Origin http:..[a-z0-9.:]+ is not allowed by Access-Control-Allow-Origin.\n/
    print output.gsub(silence_match, "")
  end

  def set_server(host, options ={})
    orig_app_host = Capybara.app_host
    protocol = options[:protocol] || "http"
    Capybara.app_host = "#{protocol}://#{host}"
    Capybara.always_include_port = true
    output = capture(:stdout) do
      yield
    end
    suppress_needless_msgs(output)
    Capybara.app_host = orig_app_host
  end

  def test_js_loader_collector_via_qunit

    # set up data to make collector test work
    joe_smith_username=CGI::escape(@joe_smith[:username])
    acme_org_api_key = CGI::escape(@acme_org[:org_api_key])

    loader_test_url = "/assets/tests/js-loader-collector-test.html"
    loader_test_params = "?username=#{joe_smith_username}"+
     "&org_api_key=#{acme_org_api_key}"+
     "&hostname=#{@lt_host}:#{@port}"
    test_url = "#{loader_test_url}#{loader_test_params}"
    set_server(@partner_host) do 
      visit(test_url)
    end
    # wait for qunit tests to execute in phantomjs
    html = wait_for_qunit(page)
    
    # verify that the collector script has been loaded by the loader script
    # ltG object is created by collector only and userId is a dynamic value inside it
    username_actual = page.evaluate_script("window.ltG.userId")
    assert_equal joe_smith_username, username_actual

    # verify tests passed in qunit
    verify_qunit_tests_passed(html)
  end


  # this method is somewhat indirect
  # It calls an html test page via capybara/poltergeist/phantomjs
  # This html page runs a series of qUnit javascript tests
  # The results of the qUnit test runs are loaded by this test method
  # Those results are in xml, which this test method parses and looks for failing tests.
  # If it finds failing tests it will fail the test run w/a message.
  # It will also save a screenshot of the failing qUnit test results page (to LT::tmp_dir)
  # It will try to open that screenshot in chrome
  def test_js_collector_via_qunit
    # set up data to make collector test work
    joe_smith_username=CGI::escape(@joe_smith[:username])
    acme_org_api_key = CGI::escape(@acme_org[:org_api_key])
    collector_test_url = "/assets/tests/js-collector-test.html"+
      "?username=#{joe_smith_username}"+
      "&org_api_key=#{acme_org_api_key}"+
      "&hostname=#{@lt_host}:#{@port}"
    collector_js_url = "/api/v1/collector.js?username=#{joe_smith_username}&org_api_key=#{acme_org_api_key}"
    # verify that we can get to the collector.js file itself without errors
    set_server(@partner_host) do 
      get(collector_js_url)
    end
    assert_equal 200, last_response.status
    # after confirming that the collector.js file is obtainable
    # we can make the full headless browser call to the test file
    html = nil
    set_server(@partner_host) do 
      visit(collector_test_url)
      html = wait_for_qunit(page)
    end
    # verify tests passed in qunit
    verify_qunit_tests_passed(html)

    # show that an initial "on page load" click message has been sent
    message = JSON.parse(LT::RedisServer.raw_message_pop)
    assert_equal RawMessage::Verbs::CLICKED, message["verb"]

  end # test_js_collector_qunit

  def test_js_display_via_qunit
    # set up data to make collector test work
    joe_smith_username=CGI::escape(@joe_smith[:username])
    acme_org_api_key = CGI::escape(@acme_org[:org_api_key])
    display_test_url = "/assets/tests/js-display-test.html?username=#{joe_smith_username}&org_api_key=#{acme_org_api_key}"
    collector_js_url = "/api/v1/collector.js"+
      "?username=#{joe_smith_username}"+
      "&org_api_key=#{acme_org_api_key}"
    # verify that we can get to the collector.js file itself without errors
    
    get(collector_js_url)
    assert_equal 200, last_response.status
    # after confirming that the collector.js file is obtainable
    # we can make the full headless browser call to the test file
    html = nil
    set_server(@partner_host) do
      visit(display_test_url)
      html = wait_for_qunit(page)
    end
    # verify tests passed in qunit
    verify_qunit_tests_passed(html)
    # if display.js were implemented, we'd expect to get a clicked message on page load
    # message = JSON.parse(LT::RedisServer.raw_message_pop)
    # assert_equal RawMessage::Verbs::CLICKED, message["verb"]

  end # test_js_collector_qunit


  # collector.js unit and functional tests
  def test_js_collector_directly
    joe_smith_username=CGI::escape(@joe_smith[:username])
    acme_org_api_key = CGI::escape(@acme_org[:org_api_key])
    collector_test_url = "/assets/tests/js-collector-test.html"+
      "?username=#{joe_smith_username}&org_api_key=#{acme_org_api_key}"+
      "&hostname=#{@lt_host}:#{@port}"
    set_server(@partner_host) do
      visit(collector_test_url)
      sleep 0.2
    end

    # clear raw messages queue (there's a clicked message that comes on page load)
    LT::RedisServer::raw_messages_queue_clear
    # validate that window.ltG.fSendMsg sends a message that is received by redis
    page_url = page.evaluate_script("window.ltG.priv.fGetCurURL();")
    page_title = page.evaluate_script("window.ltG.priv.fGetCurPageTitle();")

    pageViewScript = "window.ltG.fSendPageViewMsg();"
    page.execute_script(pageViewScript)
    # we need to wait for the ajax call to complete
    sleep 0.1
    message = LT::RedisServer.raw_message_pop
    refute_nil message, "No Redis message received from Ajax call via assert api."
    message = JSON.parse(message)
    assert_equal "0S", message["action"]["time"]
    assert_equal RawMessage::Verbs::VIEWED, message["verb"]
    assert_match page_title, message["page_title"]
    assert_equal page_url, message["url"]
    #validate url function
    page_url = page.evaluate_script("window.ltG.priv.fGetCurURL();")
    test_uri = URI::parse(page_url)
    valid_uri = URI::parse(collector_test_url)
    assert_equal valid_uri.path, test_uri.path
    assert_equal valid_uri.query, test_uri.query

    # show that fSendClickMsg works
    assert !LT::RedisServer.raw_message_pop
    pageArrivalScript = "window.ltG.fSendClickMsg();"
    page.execute_script(pageArrivalScript)
    sleep 0.1
    message = LT::RedisServer.raw_message_pop
    message = JSON.parse(message)
    assert_equal RawMessage::Verbs::CLICKED, message["verb"]
    # the first two chars are filled with junk for some reason
    assert_match page_title[2..50], message["page_title"][2..50]
    assert_equal page_url, message["url"]

    # verify that this message has a user_agent value in action
    assert_match /Mozilla/, message["action"]["user_agent"]

    # I cannot determine how to simulate a window close event in phantomjs
    # I can open a new page in the active browser which causes the close events to fire
    #  But this means we can't fully test that closing a window generates the right events
    #  In fact, Firefox 33 on Windows doesn't fire correctly close events correctly
    #    on application close (though it does fire on close tab and class app via close tab)
    #  It is possible to manually test browsers to see how they handle page close events
    #  Manual test: The way I am manually testing this feature currently is:
    #    Run Sinatra in development mode
    #    Run LT:console at terminal
    #      If dev database is not seeded with scenario already:
    #        Execute: LT::Scenarios::Students::create_joe_smith_scenario
    #      if it is already seeded, run this to be sure Redis has the org keys
    #        Execute: Organization.update_all_org_api_keys
    #      Execute: Organization.first.org_api_key
    #      Note the api-key uuid and paste it in the url below
    #    Visit the following URL in a browser
    #      http://localhost:8080/assets/tests/sandbox-test.html?username=joesmith@foo.com&org_api_key=[api_key]
    #    Load RedisDesktopManager
    #      View the dev raw messages queue
    #      TEST: Verify there is one raw message corresponding to our page open ("clicked") event
    #    Close the browser tab
    #      TEST: Verify there are now two raw messages - the second with "viewed" and 
    #        with the correct time shown in the data structure:
    #        action: time: {"NNS"}
  end
  def test_window_close_events
    joe_smith_username=CGI::escape(@joe_smith[:username])
    acme_org_api_key = CGI::escape(@acme_org[:org_api_key])
    collector_test_url = "/assets/tests/js-collector-test.html"+
     "?username=#{joe_smith_username}"+
     "&org_api_key=#{acme_org_api_key}"+
     "&hostname=#{@lt_host}:#{@port}"

    message = LT::RedisServer.raw_message_pop
    assert_nil message
    set_server(@partner_host) do
      visit(collector_test_url)
      html = wait_for_qunit(page)
    end
    message = LT::RedisServer.raw_message_pop
    message = JSON.parse(message)
    assert_equal RawMessage::Verbs::CLICKED, message["verb"]

    # we visit a new url in the same browser window, which kicks off
    # a js unload event
    set_server(@partner_host) do
      visit(collector_test_url)
      html = wait_for_qunit(page)
    end
    # first message on the stack will be a "viewed" as the previous page unloads
    message = LT::RedisServer.raw_message_pop
    message = JSON.parse(message)
    assert_equal RawMessage::Verbs::VIEWED, message["verb"]

    # next message on the stack will be a "click" from arrival onto the most recent page
    message = LT::RedisServer.raw_message_pop
    message = JSON.parse(message)
    assert_equal RawMessage::Verbs::CLICKED, message["verb"]

    #use_selenium
    #use_webkit
    # set_server(@partner_host) do
    #   visit(collector_test_url)
    #   html = wait_for_qunit(page)
    # end

    # msg = LT::RedisServer.raw_message_pop
    # while (msg) do 
    #   #puts msg
    #   msg = LT::RedisServer.raw_message_pop
    # end

    #webkit
    #page.execute_script("window.lt$(window).blur();")
    #page.execute_script("window.open('');")
    # first_window = page.driver.current_window_handle
    # second_window = page.driver.open_new_window
    # first_window = page.driver.switch_to_window(first_window)
    #page.driver.close_window(page.driver.current_window_handle)
    # page.driver.window_handles.each do |handle|
    #   #puts page.driver.methods.sort - Object.methods
    #   #page.driver.switch_to_window(handle)
    #   page.driver.close_window(handle)
    #   #page.execute_script("window.close();")
    # end

    # selenium
    # puts page.evaluate_script("window.ltG.debug.focus;")
    # page.execute_script("window.open('');")
    #orig_window = page.driver.current_window_handle
    #second_window = page.driver.open_new_window
    # sleep 0.5
    #page.driver.switch_to_window(orig_window)
    #page.execute_script("window.ltG.debug.focus+=1;")
    # puts page.evaluate_script("window.ltG.debug.focus;")
    # puts page.evaluate_script("window.ltG.debug.blur;")
    # page.driver.close_window(orig_window)
    # sleep 0.5


    # msg = LT::RedisServer.raw_message_pop
    # while (msg) do 
    #   puts msg
    #   msg = LT::RedisServer.raw_message_pop
    # end

    

    #page.execute_script("window.lt$(window).blur();")
    #page.execute_script("window.open('');")
    #page.driver.open_new_window
    #page.driver.close_window(page.driver.current_window_handle)
    # page.driver.window_handles.each do |handle|
    #   #puts page.driver.methods.sort - Object.methods
    #   #page.driver.switch_to_window(handle)
    #   page.driver.close_window(handle)
    #   #page.execute_script("window.close();")
    # end

    # NOTE: try using Capybara's function to close window instead of inside JS
    # we don't seem to be able to blur or close windows
    # and generate associated events in phantomjs
    # page.execute_script("window.blur();")
    # page.execute_script("window.focus();")
    # page.driver.browser.window_handles.each do |handle|
    #   page.driver.browser.switch_to.window(handle)
    #   page.execute_script "window.close();"
    # end
    # Use page.driver.debug to debug JS in Chrome
  end

  def setup
    super
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
    @lt_host = "lt.test.learningtapestry.com"
    @partner_host = "partner.lt.betaspaces.com"
    @port = Capybara.current_session.server.port
  end
  def teardown
    super
  end

  def save_load_screenshot(page)
    file_screenshot = File::expand_path(File::join(LT::tmp_path, "collector_errors.png"))
    page.save_screenshot(file_screenshot)
    `google-chrome #{file_screenshot}`
    file_screenshot
  end

  # loop, waiting for page to fill out qunit xml results section
  def wait_for_qunit(page)
    i = 0
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
    Nokogiri::HTML.parse(page.html)
  end

  def verify_qunit_tests_passed(html)
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
    # Sanity: make sure that we have run some tests in QUnit
    assert self.assertions >= 2, "An unknown failure has caused JS tests to not run. Results XML:\n"\
      "#{resultsXML.to_s}"
  end

end