test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

require File::expand_path(File::join(LT::partner_lib_path,'ruby/lib/learning_tapestry.rb'))
require './lib/util/csv_database_loader.rb'

class LearningTapestryLibraryTest < WebAppJSTestBase

  API_KEY = '00000000-4e89-4d15-99b5-274c19d318b6'
  API_SECRET = 'aaaaaaaaaaaa000000000000FFFFFFFFFFFF'

  def setup
    super
  end

  def teardown
    super
  end

  def app
    super
  end

  def test_initialize
    ## No API calls are made here, this tests various methods of object initialization

    ## Test initialization by configuration file
    lt_agent = LearningTapestry::Agent.new({use_ssl: false})
    refute_nil lt_agent
    assert_equal '00000000-0000-4000-8000-000000000000', lt_agent.org_api_key
    assert_equal '0123456789abcdef0123456789abcdef0000', lt_agent.org_secret_key

    ## Test initialization by passing in API key while creating new
    usernames = [ 'user1@example.com', 'user2@example.com', 'user3@example.com' ]
    filters = { date_start: '10/21/2014', date_end: '10/23/2014', section: 'CompSci - 7E302 - Data Structures' }
    lt_agent = LearningTapestry::Agent.new(org_api_key: API_KEY, org_secret_key: API_SECRET, entity: 'page_visits', filters: filters, usernames: usernames)
    refute_nil lt_agent
    assert_equal API_KEY, lt_agent.org_api_key
    assert_equal API_SECRET, lt_agent.org_secret_key
    assert_equal 'page_visits', lt_agent.entity
    assert_equal filters, lt_agent.filters
    assert_equal usernames, lt_agent.usernames

    ## Test initialization by manually setting attributes
    lt_agent = LearningTapestry::Agent.new({ignore_config_file: true, use_ssl: false})
    refute_nil lt_agent
    assert_nil lt_agent.org_api_key
    lt_agent.org_api_key = API_KEY
    lt_agent.org_secret_key = API_SECRET
    lt_agent.entity = 'site_visits'
    lt_agent.add_filter :date_start, '10/23/2014'
    lt_agent.add_filter :date_end, '10/24/2014'
    lt_agent.add_filter :section, 'CompSci - 6E209 - Parallel Processing'
    lt_agent.add_username 'user100@example.org'
    lt_agent.add_username 'user101@example.org'
    assert_equal API_KEY, lt_agent.org_api_key
    assert_equal API_SECRET, lt_agent.org_secret_key
    assert_equal 'site_visits', lt_agent.entity
    test_filters = { date_start: '10/23/2014', date_end: '10/24/2014', section: 'CompSci - 6E209 - Parallel Processing' }
    test_usernames = [ 'user100@example.org', 'user101@example.org' ]
    assert_equal test_filters, lt_agent.filters
    assert_equal test_usernames, lt_agent.usernames
  end

  def test_exceptions
    ## No API calls are made here, this tests various methods of object initialization

    lt_agent = LearningTapestry::Agent.new({ignore_config_file: true, use_ssl: false})

    exception = assert_raises LearningTapestry::LTAgentException do
      lt_agent.obtain
    end
    assert_equal 'Organization API key not provided or not valid', exception.message

    exception = assert_raises LearningTapestry::LTAgentException do
      lt_agent.org_api_key = API_KEY
      lt_agent.obtain
    end
    assert_equal 'Organization API secret not provided or not valid', exception.message

    exception = assert_raises LearningTapestry::LTAgentException do
      lt_agent.org_secret_key = API_SECRET
      lt_agent.obtain
    end
    assert_equal 'Username array not provided', exception.message

    exception = assert_raises LearningTapestry::LTAgentException do
      lt_agent.usernames = [ 'testuser' ]
      lt_agent.obtain
    end
    assert_equal 'Entity type not provided', exception.message

  end

  def test_obtain
    ## API calls made here

    DatabaseCleaner.clean
    DatabaseCleaner[:active_record].strategy = :truncation
    DatabaseCleaner.start

    ## Load up a big test fixture

    csv_file_name = File::expand_path(File::join(LT::db_path, '/csv/test/organizations.csv'))
    LT::Utilities::CsvDatabaseLoader.load_file(csv_file_name)
    csv_file_name = File::expand_path(File::join(LT::db_path, '/csv/test/users.csv'))
    LT::Utilities::CsvDatabaseLoader.load_file(csv_file_name)
    csv_file_name = File::expand_path(File::join(LT::db_path, '/csv/test/sites.csv'))
    LT::Utilities::CsvDatabaseLoader.load_file(csv_file_name)
    csv_file_name = File::expand_path(File::join(LT::db_path, '/csv/test/pages.csv'))
    LT::Utilities::CsvDatabaseLoader.load_file(csv_file_name)
    csv_file_name = File::expand_path(File::join(LT::db_path, '/csv/test/page_visits.csv'))
    LT::Utilities::CsvDatabaseLoader.load_file(csv_file_name)


    lt_agent = LearningTapestry::Agent.new({use_ssl: false})
    lt_agent.org_api_key = API_KEY
    lt_agent.org_secret_key = API_SECRET
    lt_agent.entity = 'site_visits'
    lt_agent.usernames = [ 'joesmith@foo.com' ]
    lt_agent.add_filter :date_begin, '2014-10-01'
    lt_agent.add_filter :date_end, '2014-10-31'

    port = Capybara.current_session.server.port
    lt_agent.api_base = "http://localhost:#{port}"

    response = lt_agent.obtain
    assert response
    assert_equal 200, response[:status]
    assert_equal 1, response[:results].length
    assert_equal 5, response[:results][0][:site_visits].length
    assert_equal 'site_visits', response[:entity]
    assert_equal '2014-10-01T00:00:00.000+00:00', response[:date_range][:date_begin]
    assert_equal '2014-10-31T23:59:59', response[:date_range][:date_end]
    assert_equal 'joesmith@foo.com', response[:results][0][:username]

    lt_agent.type = 'detail'

    response = lt_agent.obtain
    assert response
    assert_equal 200, response[:status]
    assert_equal 1, response[:results].length
    assert_equal 27, response[:results][0][:site_visits].length

    lt_agent.usernames = [ 'bob@foo.com', 'joesmith@foo.com' ]
    lt_agent.add_filter :date_begin, '2014-10-11'
    lt_agent.add_filter :date_end, '2014-10-17'
    lt_agent.entity = 'page_visits'
    lt_agent.type = 'summary'

    response = lt_agent.obtain
    assert_equal 200, response[:status]
    assert_equal 2, response[:results].length
    assert_equal 57, response[:results][0][:page_visits].length
    assert_equal 53, response[:results][1][:page_visits].length

    lt_agent.type = 'detail'
    response = lt_agent.obtain
    assert_equal 200, response[:status]
    assert_equal 2, response[:results].length
    assert_equal 92, response[:results][0][:page_visits].length
    assert_equal 77, response[:results][1][:page_visits].length

    DatabaseCleaner.clean
  end
end