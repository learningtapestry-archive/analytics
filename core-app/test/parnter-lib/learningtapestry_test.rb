test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

require File::expand_path(File::join(LT::partner_lib_path,'learning_tapestry.rb'))

class LearningTapestryLibraryTest < WebAppJSTestBase

  API_KEY = '5651668c-4e89-4d15-99b5-274c19d318b6'

  def setup
    super
    # Close out the base transaction, we need to change the strategy to truncation
    # based on cross-process data sharing and testing
    DatabaseCleaner.clean
    DatabaseCleaner[:active_record].strategy = :truncation
    DatabaseCleaner.start
  end

  def teardown
    super
  end

  def app
    super
  end

  def test_initialize
    ## Test initialization by passing in API key while creating new
    usernames = [ 'user1@example.com', 'user2@example.com', 'user3@example.com' ]
    filters = { date_start: '10/21/2014', date_end: '10/23/2014', section: 'CompSci - 7E302 - Data Structures' }
    lt_client = LearningTapestry::Agent.new(org_api_key: API_KEY, entity: 'page_visits', filters: filters, usernames: usernames)
    refute_nil lt_client
    assert_equal API_KEY, lt_client.org_api_key
    assert_equal 'page_visits', lt_client.entity
    assert_equal filters, lt_client.filters
    assert_equal usernames, lt_client.usernames

    ## Test initialization by passing in API key by manually setting attribute
    lt_client = LearningTapestry::Agent.new
    refute_nil lt_client
    assert_nil lt_client.org_api_key
    lt_client.org_api_key = API_KEY
    lt_client.entity = 'site_visits'
    lt_client.add_filter :date_start, '10/23/2014'
    lt_client.add_filter :date_end, '10/24/2014'
    lt_client.add_filter :section, 'CompSci - 6E209 - Parallel Processing'
    lt_client.add_username 'user100@example.org'
    lt_client.add_username 'user101@example.org'
    assert_equal API_KEY, lt_client.org_api_key
    assert_equal 'site_visits', lt_client.entity
    test_filters = { date_start: '10/23/2014', date_end: '10/24/2014', section: 'CompSci - 6E209 - Parallel Processing' }
    test_usernames = [ 'user100@example.org', 'user101@example.org' ]
    assert_equal test_filters, lt_client.filters
    assert_equal test_usernames, lt_client.usernames
  end

  def test_obtain
    scenario = LT::Scenarios::Students::create_joe_smith_scenario
    joe_smith = User.find_by_username(scenario[:student][:username])
    bob_newhart = User.find_by_username(scenario[:student2][:username])
    page_visits = scenario[:page_visits]
    sites = scenario[:sites]
    pages = scenario[:pages]
    acme_org = Organization.find_by_name(scenario[:organizations][0][:name])

    usernames = [ joe_smith.username, bob_newhart.username ]
    filters = { begin_date: Time::now - 30.days }
    lt_client = LearningTapestry::Agent.new(org_api_key: acme_org[:org_api_key], entity: 'sites_visits', filters: filters, usernames: usernames)
    refute_nil lt_client

    port = Capybara.current_session.server.port
    lt_client.api_base = "http://localhost:#{port}"
    response = lt_client.obtain

    refute_nil response
    assert_equal 200, response[:status]
    assert_equal 2, response[:data][:results].length

    bob_found = false; khanacad_found = false; codeacad_found = false;
    response[:data][:results].each do |user_result|
      if user_result[:username] == scenario[:student2][:username] then
        bob_found = true
        assert_equal 2, user_result[:site_visits].length

        user_result[:site_visits].each do |site_visit|
          codeacad_found = true if site_visit[:display_name] == LT::Scenarios::Sites.codeacademy_data[:display_name] and site_visit[:time_active] == '00:30:00'
          khanacad_found = true if site_visit[:display_name] == LT::Scenarios::Sites.khanacademy_data[:display_name] and site_visit[:time_active] == '00:41:00'
        end
      end
    end

    assert bob_found
    assert khanacad_found
    assert codeacad_found

  end
end