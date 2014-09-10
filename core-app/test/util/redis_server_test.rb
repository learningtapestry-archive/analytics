gem "minitest"
require 'minitest/autorun'
require 'debugger'
#require 'fileutils'
#require 'tempfile'
#require 'database_cleaner'
# some likely testing gems we'll want
# TimeCop, chronic, tempfile, uri
require File::join(LT::lib_path, 'util/redis_server.rb')

class RedisConfigurationTest < Minitest::Test
  def setup
    LT::RedisServer::boot_redis(File::expand_path('./db/redis.yml'))
  end

  def test_RawMessageQueue

    # Test that raw message queue is clear
    LT::RedisServer::raw_messages_queue_clear
    count = LT::RedisServer::raw_message_queue_length
    assert_equal 0, count
    
    # Test that push and pops on raw message queue
    LT::RedisServer::raw_message_push("test")
    LT::RedisServer::raw_message_push("test2")
    LT::RedisServer::raw_message_push("test3")
    count = LT::RedisServer::raw_message_queue_length
    assert_equal 3, count
    message = LT::RedisServer::raw_message_pop
    assert_equal "test", message
    message = LT::RedisServer::raw_message_pop
    assert_equal "test2", message
    message = LT::RedisServer::raw_message_pop
    assert_equal "test3", message

    # Test that all messages processed on raw message queue
    count = LT::RedisServer::raw_message_queue_length
    assert_equal 0, count
  end

  def test_APIKeysHashList
    # Test that api key hashlist is clear
    LT::RedisServer::api_keys_hashlist_clear
    count = LT::RedisServer::api_key_hashlist_length
    assert_equal 0, count
    
    # Test that valid api key set
    LT::RedisServer::api_key_set("00000000-aaaa-bbbb-cccc-000000000000", "lt-database-name")
    count = LT::RedisServer::api_key_hashlist_length
    assert_equal 1, count

    # Test that valid api key get
    database_name = LT::RedisServer::api_key_get("00000000-aaaa-bbbb-cccc-000000000000")
    assert_equal "lt-database-name", database_name

    # Test that invalid api key get
    database_name = LT::RedisServer::api_key_get("ffffffff-aaaa-bbbb-cccc-ffffffffffff")
    assert_equal nil, database_name

    # Test that valid api key remove
    database_name = LT::RedisServer::api_key_get("00000000-aaaa-bbbb-cccc-000000000000")
    assert_equal "lt-database-name", database_name
    LT::RedisServer::api_key_remove("00000000-aaaa-bbbb-cccc-000000000000")
    database_name = LT::RedisServer::api_key_get("00000000-aaaa-bbbb-cccc-000000000000")
    assert_equal nil, database_name

    # Test that api key hashlist is clear
    LT::RedisServer::api_keys_hashlist_clear
    count = LT::RedisServer::api_key_hashlist_length
    assert_equal 0, count
  end

end