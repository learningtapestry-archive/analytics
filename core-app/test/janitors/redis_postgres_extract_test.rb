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
    assert_equal scenario[:students][0][:first_name], joe_smith.first_name
    assert LT::RedisServer::raw_message_queue_length >=4
    assert_equal scenario[:raw_messages].size, LT::RedisServer::raw_message_queue_length

    # run janitor to pull from redis and push to pg raw_messages table
    LT::Janitors::RedisPostgresExtract::redis_to_raw_messages
    assert_equal 0, LT::RedisServer::raw_message_queue_length
    assert_equal scenario[:raw_messages].size, RawMessage.count
    test_msgs = RawMessage.where(:url => scenario[:raw_messages][0][:url])
      .where(:username => joe_smith_username)
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

    # convert raw_messages to appropriate page visits
    assert_equal 0, PageVisit.count
    LT::Janitors::RawMessagesExtract::raw_messages_to_page_visits

    # re-running RawMessagesExtract should not process any records

  end

  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end

  @first_run
  def before_suite
    if !@first_run
      DatabaseCleaner[:active_record].strategy = :truncation
      DatabaseCleaner[:redis].strategy = :truncation
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
    LT::RedisServer::raw_message_push("foobidy")
    count = LT::RedisServer::raw_message_queue_length
    assert_equal 1, count
  end
  def test_redis_queues_are_empty_on_start
    count = LT::RedisServer::api_key_hashlist_length
    assert_equal 0, count
    count = LT::RedisServer::raw_message_queue_length
    assert_equal 0, count
    LT::RedisServer::raw_message_push("foobidy")
    count = LT::RedisServer::raw_message_queue_length
    assert_equal 1, count
  end
end
