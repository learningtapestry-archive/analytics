test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

class ApiAppTest < WebAppTestBase
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
  end

  def teardown
    super
  end

  def test_approved_site_list
    request '/api/v1/approved-sites'
    response_json = JSON.parse(last_response.body, symbolize_names: true)
    khan_found = false ; codeacad_found = false
    response_json.each do |approved_site|
      if approved_site[:url] == LT::Scenarios::Sites.khanacademy_data[:url] then khan_found = true end
      if approved_site[:url] == LT::Scenarios::Sites.codeacademy_data[:url] then codeacad_found = true end
    end

    assert_equal true, khan_found
    assert_equal true, codeacad_found
  end

  def test_service_status
    request '/api/v1/service-status'
    response_json = JSON.parse(last_response.body, symbolize_names: true)

    assert_equal true, response_json[:database]
    assert_equal true, response_json[:redis]
  end


end