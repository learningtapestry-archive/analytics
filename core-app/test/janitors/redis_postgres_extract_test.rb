gem "minitest"
require 'minitest/autorun'
require 'debugger'
require 'database_cleaner'
require 'date'
require 'benchmark'
require File::join(LT::janitor_path,'redis_postgres_extract.rb')

class RedisPostgresExtractTest < Minitest::Test

  def test_extract_from_redis_to_pg_scenario
    # basic setup checking that data are ready for export in redis
    scenario = LT::Scenarios::RawMessages::create_raw_message_redis_to_pg_scenario
    joe_smith_username =scenario[:students][0][:username]
    joe_smith = User.find_by_username(joe_smith_username)
    joe_smith_id = joe_smith.id
    assert_equal scenario[:students][0][:first_name], joe_smith.first_name
    assert LT::RedisServer::raw_message_queue_length >=4
    assert_equal scenario[:raw_messages].size, LT::RedisServer::raw_message_queue_length

    # run janitor to pull from redis and push to pg raw_messages table
    LT::Janitors::RedisPostgresExtract::redis_to_raw_messages
    assert_equal 0, LT::RedisServer::raw_message_queue_length
    assert_equal scenario[:raw_messages].size, RawMessage.count
    test_msgs = RawMessage.where(:url => scenario[:raw_messages][0][:url])
      .where(:user_id => joe_smith_id)
      .where(['captured_at <= ?', 8.days.ago])
      .where(:verb => 'viewed')
    test_msg = test_msgs.first
    # spot check in raw_messages table that the records imported correctly
    assert_equal scenario[:raw_messages][0][:action][:value][:time], test_msg.action["value"]["time"]
    assert !test_msg.action["value"]["time"].nil?
    # verify that raw_message_logs table entries were created as well
    logs = test_msg.raw_message_logs
    assert_equal RawMessageLog::Actions::FROM_REDIS, logs.first.action
    assert_equal 1, test_msg.raw_message_logs.size

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


    # convert raw_messages to appropriate page visits
    LT::Janitors::RawMessagesExtract::raw_messages_to_page_visits
    assert_equal scenario[:raw_messages].size, PageVisit.count
    # spot check data
    # verify that the correct user was attached to a page_visit record
    duration = ChronicDuration.parse(scenario[:raw_messages][0][:action][:value][:time])
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
    # re-running RawMessagesExtract should not process any records
    #  this confirms that RawMessages that were processed have been correctly
    #  tagged as having already been processed into page_visits
    LT::Janitors::RawMessagesExtract::raw_messages_to_page_visits
    assert_equal scenario[:raw_messages].size, PageVisit.count

  end

  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end

  @first_run
  def before_suite
    if !@first_run
      DatabaseCleaner[:active_record].strategy = :transaction
      DatabaseCleaner[:redis].strategy = :truncation
      DatabaseCleaner[:redis, {connection: LT::RedisServer.connection_string}]
    end
    @first_run = true
  end

  def setup
    before_suite
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
  end



  # we have two tests b/c one has to run before the other
  # guaranteeing we'll detect failures by DatabaseCleaner to clear Redis
  def test_redis_queues_are_empty_on_start2
    count = LT::RedisServer::api_key_hashlist_length
    assert_equal 0, count
    count = LT::RedisServer::raw_message_queue_length
    assert_equal 0, count
    # test raw message queue
    LT::RedisServer::raw_message_push("foobidy")
    count = LT::RedisServer::raw_message_queue_length
    assert_equal 1, count
    # test api_key queue
    key = "foo"
    value = "bar"
    LT::RedisServer::api_key_set(key, value)
    ret_value = LT::RedisServer::api_key_get(key)
    assert_equal value, ret_value
  end
  def test_redis_queues_are_empty_on_start
    count = LT::RedisServer::api_key_hashlist_length
    assert_equal 0, count
    count = LT::RedisServer::raw_message_queue_length
    assert_equal 0, count
    # test raw message queue
    LT::RedisServer::raw_message_push("foobidy")
    count = LT::RedisServer::raw_message_queue_length
    assert_equal 1, count
    # test api_key queue
    key = "foo"
    value = "bar"
    LT::RedisServer::api_key_set(key, value)
    ret_value = LT::RedisServer::api_key_get(key)
    assert_equal value, ret_value
  end
end
