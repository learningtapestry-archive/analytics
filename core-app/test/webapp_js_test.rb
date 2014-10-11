test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

class WebAppJSTest < WebAppJSTestBase

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
  def test_js_collector_via_qunit
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
    # Sanity: make sure that we have run some tests in QUnit
    assert self.assertions >= 2, "An unknown failure has caused JS tests to not run. Results XML:\n"\
      "#{resultsXML.to_s}"
    # show that an initial "on page load" click message has been sent
    message = JSON.parse(LT::RedisServer.raw_message_pop)
    assert_equal RawMessage::Verbs::CLICKED, message["verb"]

  end # test_js_collector_qunit

  def test_js_display_via_qunit

    # set up data to make collector test work
    joe_smith_username=CGI::escape(@joe_smith[:username])
    acme_org_api_key = CGI::escape(@acme_org[:org_api_key])
    display_test_url = "/assets/tests/js-display-test.html?username=#{joe_smith_username}&org_api_key=#{acme_org_api_key}"
    collector_js_url = "/api/v1/collector.js?username=#{joe_smith_username}&org_api_key=#{acme_org_api_key}"
    # verify that we can get to the collector.js file itself without errors
    get(collector_js_url)
    assert_equal 200, last_response.status
    # after confirming that the collector.js file is obtainable
    # we can make the full headless browser call to the test file
    visit(display_test_url)
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
    # Sanity: make sure that we have run some tests in QUnit
    assert self.assertions >= 2, "An unknown failure has caused JS QUnit for Display tests to not run. Results XML:\n"\
      "#{resultsXML.to_s}"
    # show that an initial "on page load" click message has been sent
    message = JSON.parse(LT::RedisServer.raw_message_pop)
    assert_equal RawMessage::Verbs::CLICKED, message["verb"]

  end # test_js_collector_qunit


  # collector.js unit and functional tests
  def test_js_collector_directly
    joe_smith_username=CGI::escape(@joe_smith[:username])
    acme_org_api_key = CGI::escape(@acme_org[:org_api_key])

    collector_test_url = "/assets/tests/js-collector-test.html?username=#{joe_smith_username}&org_api_key=#{acme_org_api_key}"
    visit(collector_test_url)
    sleep 0.2
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
    pageViewScript = "window.ltG.fSendClickMsg();"
    page.execute_script(pageViewScript)
    sleep 0.1
    message = LT::RedisServer.raw_message_pop
    message = JSON.parse(message)
    assert_equal RawMessage::Verbs::CLICKED, message["verb"]
    assert_match page_title, message["page_title"]
    assert_equal page_url, message["url"]

    # verify that this message has a user_agent value in action
    assert_match /^Mozilla\/5.0.*PhantomJS/, message["action"]["user_agent"]

    # TODO TEST WARNING: I cannot determine how to simulate a window close event in phantomjs
    #  This means that we cannot programmatically verify that closing a window
    #  will trigger the a "viewed" event with a correct "time on page" duration
    #  Manual test: The way I am manually testing this feature currently is:
    #    Run Sinatra in development mode
    #    Run LT:console at terminal
    #      Execute: LT::Scenarios::Students::create_joe_smith_scenario
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


    # we don't seem to be able to blur or close windows
    # and generate associated events in phantomjs
    # page.execute_script("window.blur();")
    # page.execute_script("window.focus();")
    # page.driver.browser.window_handles.each do |handle|
    #   page.driver.browser.switch_to.window(handle)
    #   page.execute_script "window.close();"

    # end

    #page.execute_script("window.close();")

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
  end
  def teardown
    super
  end

end