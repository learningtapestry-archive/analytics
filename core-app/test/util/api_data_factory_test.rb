test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

require './lib/util/api_data_factory.rb'

class APIDataFactoryTest < LTDBTestBase
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
    @organization = @scenario[:organization]
  end

  def teardown
    super
  end

  def test_site_visits_by_usernames
    user = User.find_by_username @scenario[:student][:username]
    org = user.organization
    params = {}
    params[:org_api_key] = org.org_api_key
    params[:usernames] = [ @joe_smith[:username] ]
    resultset = LT::Utilities::APIDataFactory.site_visits(params)

    assert resultset
    assert_equal 2, resultset[:results][0].length
    assert_equal '00:34:00', resultset[:results][0][:site_visits][0][:time_active]
    assert_equal '00:08:00', resultset[:results][0][:site_visits][1][:time_active]
  end

end