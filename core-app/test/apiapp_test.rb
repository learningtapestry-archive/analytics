test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file
require './lib/util/csv_database_loader.rb'
require File::join(LT::janitor_path,'redis_postgres_extract.rb')

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
    @org = @scenario[:organizations][0]
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

    assert_equal 200, last_response.status
    assert_equal true, khan_found
    assert_equal true, codeacad_found
  end

  def test_service_status
    request '/api/v1/service-status'
    response_json = JSON.parse(last_response.body, symbolize_names: true)

    assert_equal 200, last_response.status
    assert_equal true, response_json[:database]
    assert_equal true, response_json[:redis]
  end

  def test_obtain
    response_json = nil

    ### Test basic API call, don't expect to get back results, but check API shape
    params = { org_api_key: @org[:org_api_key],
               org_secret_key: @org[:org_secret_key],
               usernames: [ @joe_smith[:username] ],
               entity: 'site_visits' }
    post '/api/v1/obtain', params.to_json, 'content_type' => 'application/json' do
      body = last_response.body
      response_json = JSON.parse(body, symbolize_names: true) if body and body != 'null'
    end

    assert_equal 200, last_response.status
    assert response_json
    assert_equal response_json[:entity], 'site_visits'
    assert_equal (DateTime.now - 1.day).to_date, DateTime.parse(response_json[:date_range][:date_begin]).to_date
    assert_equal (DateTime.now).to_date, DateTime.parse(response_json[:date_range][:date_end]).to_date
    assert_equal response_json[:results], []

    params[:date_begin] = '2014-01-01'
    params[:date_end] = DateTime.now
    params[:entity] = 'page_visits'
    post '/api/v1/obtain', params.to_json, 'content_type' => 'application/json' do
      body = last_response.body
      response_json = JSON.parse(body, symbolize_names: true) if body and body != 'null'
    end

    ### Test a valid page_visit response (more tests avialable in LT::Utilities::APIDataFactory test suite)
    assert_equal 200, last_response.status
    assert response_json
    assert_equal response_json[:entity], 'page_visits'
    assert_equal @joe_smith[:username], response_json[:results][0][:username]
  end

  def test_obtain_fails

    ### No org_api_key or org_secret_key fail test

    response_json = nil

    params = { test: 'test' }
    post '/api/v1/obtain', params.to_json, 'content_type' => 'application/json' do
      response_json = JSON.parse(last_response.body, symbolize_names: true)
    end

    assert_equal 401, last_response.status
    assert_equal 'Organization API key (org_api_key) and secret (org_secret_key) not provided', response_json[:error]

    ### No usernames fail test

    params = { org_api_key: 'test', org_secret_key: 'test' }
    post '/api/v1/obtain', params.to_json, 'content_type' => 'application/json' do
      response_json = JSON.parse(last_response.body, symbolize_names: true)
    end

    assert_equal 400, last_response.status
    assert_equal 'Username array (usernames) not provided', response_json[:error]

    ### No entity fail test

    params[:usernames] = [ 'dummyuser' ]
    post '/api/v1/obtain', params.to_json, 'content_type' => 'application/json' do
      response_json = JSON.parse(last_response.body, symbolize_names: true)
    end

    assert_equal 400, last_response.status
    assert_equal 'Entity type (entity) not provided', response_json[:error]

    ### Bad entity fail test

    params[:org_api_key] = @org[:org_api_key]
    params[:org_secret_key] = @org[:org_secret_key]
    params[:entity] = 'junkentity'
    post '/api/v1/obtain', params.to_json, 'content_type' => 'application/json' do
      response_json = JSON.parse(last_response.body, symbolize_names: true)
    end

    assert_equal 400, last_response.status
    assert_equal 'Unknown entity type: junkentity', response_json[:error]

  end

  def test_users

    ## No parameters test
    get '/api/v1/users' do
      response_json = JSON.parse(last_response.body, symbolize_names: true) if last_response.body and last_response.body != 'null'
      assert_equal 401, last_response.status
      assert_equal 'Organization API key (org_api_key) and secret (org_secret_key) not provided', response_json[:error]
    end

    ## Invalid api_key test
    params = { org_api_key: 'ffffffff-ffff-4d15-99b5-274c19d318b6', org_secret_key: @org[:org_secret_key] }
    get '/api/v1/users', params  do
      response_json = JSON.parse(last_response.body, symbolize_names: true) if last_response.body and last_response.body != 'null'
      assert_equal 401, last_response.status
      assert_equal 'org_api_key invalid or locked', response_json[:error]
    end

    ## Invalid secret_key test
    params = { org_api_key: @org[:org_api_key], org_secret_key: 'badsecret' }
    get '/api/v1/users', params  do
      response_json = JSON.parse(last_response.body, symbolize_names: true) if last_response.body and last_response.body != 'null'
      assert_equal 401, last_response.status
      assert_equal 'org_api_key invalid or locked', response_json[:error]
    end

    ## Valid test, receive two users
    params = { org_api_key: @org[:org_api_key], org_secret_key: @org[:org_secret_key] }
    get '/api/v1/users', params  do
      response_json = JSON.parse(last_response.body, symbolize_names: true) if last_response.body and last_response.body != 'null'
      assert_equal 200, last_response.status
      assert response_json[:results]
      assert_equal 2, response_json[:results].length
      joe_found = false; bob_found = false
      response_json[:results].each do |user|
        joe_found = true if user[:first_name] == 'Joe' and user[:last_name] == 'Smith' and user[:username] == 'joesmith@foo.com'
        bob_found = true if user[:first_name] == 'Bob' and user[:last_name] == 'Newhart' and user[:username] == 'bob@foo.com'
      end

      assert joe_found
      assert bob_found
    end
  end

  def test_video_views
    csv_file_name = File::expand_path(File::join(LT::db_path, '/csv/test/raw_messages.csv'))
    LT::Utilities::CsvDatabaseLoader.load_file(csv_file_name)
    csv_file_name = File::expand_path(File::join(LT::db_path, '/csv/test/organizations.csv'))
    LT::Utilities::CsvDatabaseLoader.load_file(csv_file_name)
    csv_file_name = File::expand_path(File::join(LT::db_path, '/csv/test/users.csv'))
    LT::Utilities::CsvDatabaseLoader.load_file(csv_file_name)

    assert_equal 38, RawMessage.all.count

    LT::Janitors::RawMessagesExtract.raw_messages_to_video_visits
    assert_equal 4, VideoView.all.count
    assert_equal 2, Video.all.count

    ## Valid test, receive two users
    params = { org_api_key: '00000000-0000-4000-8000-000000000000', org_secret_key: 'secret' }
    get '/api/v1/video_views', params do
      response_json = JSON.parse(last_response.body, symbolize_names: true) if last_response.body and last_response.body != 'null'
      assert_equal 200, last_response.status
      assert response_json
      assert_equal 4, response_json.length
      joe_found = false; bob_found = false
      response_json.each do |user|
        joe_found = true if user[:username] == 'joesmith@foo.com'
        bob_found = true if user[:username] == 'bob@foo.com'
      end

      assert joe_found
      assert bob_found
    end
  end

end