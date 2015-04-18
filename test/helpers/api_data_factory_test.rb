test_helper_file = File::expand_path(File::join(LT.environment.test_path,'test_helper.rb'))
require test_helper_file

require 'helpers/api_data_factory.rb'
require 'utils/csv_database_loader'

class APIDataFactoryTest < LTDBTestBase
  def setup
    super

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

    @webapp = Object.new
    @webapp.extend(Analytics::Helpers::APIDataFactory)
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
    params[:date_begin] = '2014-10-01'
    params[:date_end] = '2014-10-31'
    resultset = @webapp.site_visits(params)

    assert resultset
    assert_equal 'site_visits', resultset[:entity]
    assert_equal 1, resultset[:results].length

    joe_visits = find_username('joesmith@foo.com', resultset[:results])
    assert_equal 'joesmith@foo.com', joe_visits[:username]
    assert_equal 5, joe_visits[:site_visits].length

    site = find_site_visit_by_url('stackoverflow.com', joe_visits[:site_visits])
    assert_equal 'Stack Overflow', site[:site_name]
    assert_equal 'stackoverflow.com', site[:site_domain]
    assert_equal '23:36:24', site[:time_active]

    ## Test again one user, one domain

    params[:site_domains] = [ 'slashdot.org' ] # Apply site domain filter
    resultset = @webapp.site_visits(params)

    joe_visits = find_username('joesmith@foo.com', resultset[:results])
    assert_equal 'joesmith@foo.com', joe_visits[:username]
    assert_equal 1, joe_visits[:site_visits].length

    site = find_site_visit_by_url('slashdot.org', joe_visits[:site_visits])
    assert site
    assert_equal 'Slashdot', site[:site_name]
    assert_equal '00:00:05', site[:time_active]

    ## Test with two users (Joe and Bob)

    params = {}
    params[:org_api_key] = org.org_api_key
    params[:usernames] = [ user1.username, user2.username ]
    params[:date_begin] = '2014-10-11T08:00:00'
    params[:date_end] = '2014-10-21T23:00:00'
    resultset = @webapp.site_visits(params)

    assert resultset
    assert_equal 'site_visits', resultset[:entity]
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
    assert_nil site[:date_visited]

    ## Test with two users (Joe and Bob) with date details

    params[:type] = 'detail'
    resultset = @webapp.site_visits(params)

    assert resultset
    joe_visits = find_username('joesmith@foo.com', resultset[:results])
    assert joe_visits
    site = find_site_visit_by_url('slashdot.org', joe_visits[:site_visits])
    assert site
    assert site[:date_visited]
  end

  def test_page_visits_by_usernames
    user1 = User.find_by_username 'joesmith@foo.com'
    assert user1
    user2 = User.find_by_username 'bob@foo.com'
    assert user2

    org = user1.organization
    params = {}

    ## Test with one user (Joe) summary (default) view

    params[:org_api_key] = org.org_api_key
    params[:usernames] = [ user1.username ]
    params[:date_begin] = '2014-10-11'
    params[:date_end] = '2014-10-12'
    resultset = @webapp.page_visits(params)

    assert_equal 'page_visits', resultset[:entity]
    assert_equal DateTime.parse('2014-10-11'), resultset[:date_range][:date_begin]
    assert_equal DateTime.parse('2014-10-12T23:59:59'), resultset[:date_range][:date_end]
    assert_equal 1, resultset[:results].length

    joe_visits = find_username('joesmith@foo.com', resultset[:results])
    assert_equal 'joesmith@foo.com', joe_visits[:username]
    assert_equal 19, joe_visits[:page_visits].length

    assert joe_visits[:page_visits][0][:site_name]
    assert joe_visits[:page_visits][0][:site_domain]
    assert joe_visits[:page_visits][0][:page_name]
    assert joe_visits[:page_visits][0][:page_url]
    assert joe_visits[:page_visits][0][:time_active]
    assert_nil joe_visits[:page_visits][0][:date_visited]

    ## Test again with one user (Joe) detail view

    params[:type] = 'detail'
    resultset = @webapp.page_visits(params)

    joe_visits = find_username('joesmith@foo.com', resultset[:results])
    assert_equal 'joesmith@foo.com', joe_visits[:username]
    assert_equal 30, joe_visits[:page_visits].length
    assert joe_visits[:page_visits][0][:page_name]
    assert joe_visits[:page_visits][0][:date_visited]

    ## Test with two users (Joe and Bob) detail view

    params[:usernames] = [ user1.username, user2.username ]
    params[:type] = 'detail'
    params[:date_begin] = '2014-10-13'
    params[:date_end] = '2014-10-14'

    resultset = @webapp.page_visits(params)

    assert_equal 'page_visits', resultset[:entity]
    assert_equal 2, resultset[:results].length
    joe_visits = find_username('joesmith@foo.com', resultset[:results])
    bob_visits = find_username('bob@foo.com', resultset[:results])
    assert_equal 26, joe_visits[:page_visits].length
    assert_equal 28, bob_visits[:page_visits].length
    assert joe_visits[:page_visits][0][:page_name]
    assert joe_visits[:page_visits][0][:date_visited]
    assert bob_visits[:page_visits][0][:page_name]
    assert bob_visits[:page_visits][0][:date_visited]

    ## Test with two users (Joe and Bob) detail view, two specific pages

=begin
    page_urls = [ 'http://stackoverflow.com/questions/17333994/how-to-copy-one-column-of-a-table-into-another-tables-column-in-postgresql-comp', 'http://stackoverflow.com/questions/17877220/how-should-hateoas-style-links-be-implemented-for-restful-json-collections' ]

    params[:date_begin] = '2014-10-01'
    params[:date_end] = '2014-10-31'
    params[:page_urls] = [ page_urls ]
    resultset = @webapp.page_visits(params)

    joe_visits = find_username('joesmith@foo.com', resultset[:results])
    bob_visits = find_username('bob@foo.com', resultset[:results])

    [joe_visits, bob_visits].each do |visit|
      visit[:page_visits].each do |page_visit|
        assert page_visit[:page_url]
        assert (page_visit[:page_url] == page_urls[0] or page_visit[:page_url] == page_urls[1])
      end
    end

    params[:page_urls] = nil
    params[:date_begin] = '2014-10-01'
    params[:date_end] = '2014-10-31'
    params[:site_domains] = 'arstechnica.com'
    resultset = @webapp.page_visits(params)

    assert resultset
    joe_visits = find_username('joesmith@foo.com', resultset[:results])
    joe_visits[:page_visits].each do |page_visit|
      assert 'arstechnica.com', page_visit[:site_domain]
    end
=end

  end


  def find_site_visit_by_url(url, items)
    items.each do |item|
        return item if item[:site_domain] == url
    end
    nil
  end

  def find_username(username, items)
    items.each do |item|
      return item if item[:username] == username
    end
    nil
  end

end
