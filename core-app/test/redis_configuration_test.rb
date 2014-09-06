gem "minitest"
require 'minitest/autorun'
require 'debugger'
#require 'fileutils'
#require 'tempfile'
#require 'database_cleaner'
# some likely testing gems we'll want
# TimeCop, chronic, tempfile, uri
require File::join(LT::Janitor::lib_path, 'util/redis_server.rb')

class RedisConfigurationTest < Minitest::Test
  def setup
    LT::RedisServer::boot_redis(File::expand_path('./db/redis.yml'))
  end

  def test_RawMessageQueue
    LT::RedisServer::raw_messages_queue_clear
    LT::RedisServer::raw_message_push("test")
    LT::RedisServer::raw_message_push("test2")
    LT::RedisServer::raw_message_push("test3")
    count = LT::RedisServer::raw_message_length
    assert_equal 3, count
    message = LT::RedisServer::raw_message_pop
    assert_equal "test", message
    message = LT::RedisServer::raw_message_pop
    assert_equal "test2", message
    message = LT::RedisServer::raw_message_pop
    assert_equal message, "test3"
  end

  def test_APIKeysHashList
    skip "Coming soon"
  end



end