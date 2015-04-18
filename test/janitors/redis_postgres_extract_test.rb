test_helper_file = File::expand_path(File::join(LT.environment.test_path,'test_helper.rb'))
require test_helper_file

require 'date'
require File::join(LT.environment.janitor_path,'redis_postgres_extract.rb')

require 'utils/csv_database_loader'
require 'utils/scenarios'

require 'helpers/redis'

class RedisPostgresExtractTest < LTDBTestBase
  include Analytics::Helpers::Redis

  def test_extract_from_redis_to_pg_scenario
    # basic setup checking that data are ready for export in redis
    scenario = Analytics::Utils::Scenarios::RawMessages::create_raw_message_redis_to_pg_scenario
    joe_smith_username =scenario[:students][0][:username]
    joe_smith = User.find_by_username(joe_smith_username)
    joe_smith_id = joe_smith.id
    new_student_username = scenario[:new_student][:username]
    acme_org_api_key = scenario[:organizations].first[:org_api_key]
    assert_equal scenario[:students][0][:first_name], joe_smith.first_name
    assert messages_queue.length >=4
    assert_equal scenario[:raw_messages].size, messages_queue.length
    # run janitor to pull from redis and push to pg raw_messages table
    Analytics::Janitors::RedisPostgresExtract::redis_to_raw_messages
    assert_equal 0, messages_queue.length
    assert_equal scenario[:raw_messages].size, RawMessage.count
    test_msgs = RawMessage.where(:url => scenario[:raw_messages][0][:url])
      .where(:user_id => joe_smith_id)
      .where(['captured_at <= ?', 8.days.ago])
      .where(:verb => 'viewed')
    test_msg = test_msgs.first
    # spot check in raw_messages table that the records imported correctly
    assert_equal scenario[:raw_messages][0][:action][:time], test_msg.action["time"]
    # show this record doesn't have an org id (b/c no org_api_key in incoming raw message)
    assert_equal nil, test_msg.organization_id
    assert !test_msg.action["time"].nil?

    # spot check in raw_messages table that the records imported correctly
    # verify that raw_message_logs table entries were created as well
    logs = test_msg.raw_message_logs
    assert_equal RawMessageLog::Actions::FROM_REDIS, logs.first.action
    assert_equal 1, test_msg.raw_message_logs.size
    # verify that org_api_key message was correctly created in raw_messages
    joe_smith_org_api_raw_message = RawMessage
      .where(org_api_key: acme_org_api_key)
      .where(username: joe_smith_username)
      .first
    new_student_org_api_raw_message = RawMessage
      .where(org_api_key: acme_org_api_key)
      .where(username: new_student_username)
      .first
    assert_equal acme_org_api_key, joe_smith_org_api_raw_message.org_api_key
    assert_equal acme_org_api_key, new_student_org_api_raw_message.org_api_key

    # prep/verify data before converting raw to pv
    assert_equal 0, PageVisit.count
    # create a new raw message, add a "to_page_visits" log entry
    rm = RawMessage.create_from_json(scenario[:raw_messages][0].to_json)
    rm.raw_message_logs << RawMessageLog.new_to_page_visits
    rm.save!
    sql = RawMessage.find_new_page_visits.to_sql
    # show that this new raw message doesn't show up when we query for new page visit messages
    assert_equal scenario[:raw_messages].size, RawMessage.find_new_page_visits.size
    assert_equal scenario[:raw_messages].size+1, RawMessage.all.size

    # verify that org_api_key was correctly converted to Org ID for raw messages
    # where an org api key was provided
    test_msg = scenario[:raw_messages][4]
    org = Organization.find_by_org_api_key(test_msg[:org_api_key])
    raw_msg = RawMessage.where(:url => test_msg[:url])
      .where(['org_api_key = ?', test_msg[:org_api_key]])
      .where(:verb => 'viewed')
      .where(:username => Analytics::Utils::Scenarios::Students::joe_smith_data[:username])
      .first
    refute_nil org.id
    refute_nil raw_msg.id
    assert_equal org.id, raw_msg.organization_id

    # convert raw_messages to appropriate page visits
    Analytics::Janitors::RawMessagesExtract::raw_messages_to_page_visits
    assert_equal scenario[:raw_messages].size, PageVisit.count
    # spot check data
    # verify that the correct user was attached to a page_visit record
    duration = ChronicDuration.parse(scenario[:raw_messages][0][:action][:time])
    pvs = PageVisit
      .joins(:page)
      .joins(:user)
      .where(time_active: "#{duration} seconds")
      .where("#{Page.table_name}.url" => scenario[:raw_messages][0][:url])
    assert_equal 1, pvs.size
    pv = pvs.first
    refute_nil pv
    assert_equal joe_smith_username, pv.student.username
    # verify that page_title is correctly translated to pages.display_name
    pvs = PageVisit
      .joins(:page)
      .where("#{Page.table_name}.display_name" => scenario[:raw_messages][1][:page_title])
    assert_equal scenario[:raw_messages][1][:page_title], pvs.first.page.display_name
    site_url = Site::url_to_canonical(scenario[:raw_messages][1][:url])
    assert_equal site_url, pvs.first.site.url
    # verify that exactly 1 site was correctly created
    site = Site.where(url: site_url)
    assert_equal 1, site.size
    assert_equal site_url, site.first.url

    # verify that we can find the org_api raw message as a PageVisit
    date_visited = joe_smith_org_api_raw_message.captured_at
    username = joe_smith_org_api_raw_message.username
    org_api_key = joe_smith_org_api_raw_message.org_api_key
    org = Organization.find_by_org_api_key(org_api_key)
    # find the joe smith user associated with this organization
    org_joe_smith = User.where(username: username)
      .where(organization_id: org.id)
      .first
    pv = PageVisit.find_by_date_visited(date_visited)
    assert_equal date_visited, pv.date_visited
    refute_nil org_joe_smith.id
    # username should have been translated into user id
    assert_equal org_joe_smith.id, pv.user_id

    # verify we can find a page_visit that is aligned to a non-existing user
    date_visited = new_student_org_api_raw_message.captured_at
    pv = PageVisit.find_by_date_visited(date_visited)
    assert_equal date_visited, pv.date_visited
    new_student = User.find_by_username(new_student_username)
    # username should have been translated into user id
    assert_equal new_student.id, pv.user_id
    assert new_student.id > 0
    org_api_key = Analytics::Utils::Scenarios::Organizations::acme_organization_data[:org_api_key]
    org = Organization.find_by_org_api_key(org_api_key)
    refute_nil org.id
    assert_equal org.id, new_student.organization_id

    # re-running RawMessagesExtract should not process any records
    #  this confirms that RawMessages that were processed have been correctly
    #  tagged as having already been processed into page_visits
    Analytics::Janitors::RawMessagesExtract::raw_messages_to_page_visits
    assert_equal scenario[:raw_messages].size, PageVisit.count
  end

  def test_extract_from_raw_messages_to_video_view
    csv_file_name = File::expand_path(File::join(LT.environment.db_path, '/csv/test/raw_messages.csv'))
    Analytics::Utils::CsvDatabaseLoader.load_file(csv_file_name)
    csv_file_name = File::expand_path(File::join(LT.environment.db_path, '/csv/test/organizations.csv'))
    Analytics::Utils::CsvDatabaseLoader.load_file(csv_file_name)
    assert_equal 38, RawMessage.all.count

    Analytics::Janitors::RawMessagesExtract.raw_messages_to_video_visits
    assert_equal 4, VideoView.all.count
    assert_equal 2, Video.all.count
  end
end
