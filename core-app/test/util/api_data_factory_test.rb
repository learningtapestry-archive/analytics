test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

require './lib/util/api_data_factory.rb'
require './lib/util/csv_database_loader.rb'

class APIDataFactoryTest < LTDBTestBase
  def setup
    super

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
  end

  def teardown
    super
  end

  def test_has_fixture_data
    assert_equal 1, Organization.all.length
    assert_equal 3, User.all.length
    assert_equal 11, Site.all.length
    assert_equal 308, Page.all.length
    assert_equal 694, PageVisit.all.length
  end

  def test_site_visits_by_usernames

    user1 = User.find_by_username 'joesmith@foo.com'
    assert user1
    user2 = User.find_by_username 'bob@foo.com'
    assert user2

    org = user1.organization
    params = {}
    params[:org_api_key] = org.org_api_key
    params[:usernames] = [ user1.username ]
    params[:date_begin] = '10/01/2014'
    params[:date_end] = '10/31/2014'
    resultset = LT::Utilities::APIDataFactory.site_visits(params)

    assert resultset
    assert_equal 'site_visits', resultset[:entity_type]
    assert_equal 1, resultset[:results].length
    assert_equal 'joesmith@foo.com', resultset[:results][0][:username]
    assert_equal 5, resultset[:results][0][:site_visits].length

    site = find_site_visit_by_url 'stackoverflow.com', resultset[:results][0][:site_visits]
    assert_equal 'Stack Overflow', site[:display_name]
    assert_equal '23:26:05', site[:time_active]

    params[:usernames] = [ user1.username, user2.username ]
    params[:date_begin] = '10/11/2014 08:00:00'
    params[:date_end] = '10/21/2014 23:00:00'
    resultset = LT::Utilities::APIDataFactory.site_visits(params)

    assert resultset
    assert_equal 'site_visits', resultset[:entity_type]
    assert_equal 2, resultset[:results].length

    bob_visits = find_username('bob@foo.com', resultset[:results])
    assert bob_visits
    site = find_site_visit_by_url('arstechnica.com', bob_visits[:site_visits])
    assert site
    assert_equal '00:03:17', site[:time_active]

    joe_visits = find_username('joesmith@foo.com', resultset[:results])
    assert joe_visits
    site = find_site_visit_by_url('slashdot.org', joe_visits[:site_visits])
    assert site
    assert_equal '00:00:05', site[:time_active]

  end


  def find_site_visit_by_url(url, items)
    items.each do |item|
        return item if item[:url] == url
    end
  end

  def find_username(username, items)
    items.each do |item|
      return item if item[:username] == username
    end
  end

end