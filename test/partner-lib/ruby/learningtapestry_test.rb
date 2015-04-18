test_helper_file = File::expand_path(File::join(LT.environment.test_path,'test_helper.rb'))
require test_helper_file

require File::expand_path(File::join(LT.environment.partner_lib_path,'ruby/lib/learning_tapestry.rb'))
require 'utils/csv_database_loader'

# cross-thread AR bug when Capybara is running a server alongside our testing code
# disable connection pooling with this monkey patch
# http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

class LearningTapestryLibraryTest < WebAppJSTestBase
  API_KEY = '00000000-0000-4000-8000-000000000000'
  API_SECRET = 'secret'

  def setup
    super
    # Forces all threads to share the same connection. This works on
    # Capybara because it starts the web server in a thread.
    ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

    ## Load up a big test fixture

    csv_file_name = File::expand_path(File::join(LT.environment.db_path, '/csv/test/organizations.csv'))
    Analytics::Utils::CsvDatabaseLoader.load_file(csv_file_name)
    csv_file_name = File::expand_path(File::join(LT.environment.db_path, '/csv/test/users.csv'))
    Analytics::Utils::CsvDatabaseLoader.load_file(csv_file_name)
    csv_file_name = File::expand_path(File::join(LT.environment.db_path, '/csv/test/sites.csv'))
    Analytics::Utils::CsvDatabaseLoader.load_file(csv_file_name)
    csv_file_name = File::expand_path(File::join(LT.environment.db_path, '/csv/test/pages.csv'))
    Analytics::Utils::CsvDatabaseLoader.load_file(csv_file_name)
    csv_file_name = File::expand_path(File::join(LT.environment.db_path, '/csv/test/page_visits.csv'))
    Analytics::Utils::CsvDatabaseLoader.load_file(csv_file_name)
  end

  def teardown
    super
    # disable single AR connection (enable connection pooling)
    # (to make sure we don't leave it enabled for other test suites!)
    ActiveRecord::Base.shared_connection = nil
  end

  def app
    super
  end

  def test_initialize
    ## No API calls are made here, this tests various methods of object initialization

    ## Test initialization by configuration file
    path = File::expand_path(File::dirname(__FILE__))
    config_file = File::join(path, 'config-test.yml')
    assert File::exists?(config_file)
    lt_agent = LearningTapestry::Agent.new({use_ssl: false, config_file: config_file})
    refute_nil lt_agent
    assert_equal API_KEY, lt_agent.org_api_key
    assert_equal API_SECRET, lt_agent.org_secret_key

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
  end

  def test_users
    lt_agent = LearningTapestry::Agent.new({use_ssl: false})
    lt_agent.org_api_key = API_KEY
    lt_agent.org_secret_key = API_SECRET
    port = Capybara.current_session.server.port
    lt_agent.api_base = "http://localhost:#{port}"
    response = lt_agent.users
    assert response
    assert_equal 200, response[:status]
    assert_equal 3, response[:results].length
    bob_found = false; joe_found = false; jane_found = false
    response[:results].each do |user|
      bob_found = true if user[:username] == 'bob@foo.com'
      joe_found = true if user[:username] == 'joesmith@foo.com"'
      jane_found = true if user[:username] == 'janedoe@bar.com'
    end
    assert bob_found and joe_found and jane_found
  end

end
