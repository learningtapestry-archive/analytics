require File.expand_path('../../test_helper', __FILE__)

require 'helpers/redis'

module Analytics
  module Test
    class HashWrapperTest < LT::Test::RedisTestBase
      def setup
        super

        @hash_wrapper = Helpers::Redis::HashWrapper.new(connection, 'a_hash')
      end

      def test_clear
        connection.hset 'a_hash', 'my_key', '5'

        assert_equal 1, connection.hlen('a_hash')
        @hash_wrapper.clear
        assert_equal 0, connection.hlen('a_hash')
      end

      def test_key?
        connection.hset('a_hash', 'my_key', '5')

        assert_equal true, @hash_wrapper.key?('my_key')
        connection.hdel('a_hash', 'my_key')
        assert_equal false, @hash_wrapper.key?('my_key')
      end

      def test_get
        connection.hset('a_hash', 'my_key', '5')

        assert_equal '5', @hash_wrapper.get('my_key')
        connection.hdel('a_hash', 'my_key')
        assert_nil nil, @hash_wrapper.get('my_key')
      end

      def test_set
        assert_equal nil, connection.hget('a_hash', 'my_key')
        @hash_wrapper.set('my_key', '5')
        assert_equal '5', connection.hget('a_hash', 'my_key')

        connection.hdel('a_hash', 'my_key')
      end

      def test_remove
        connection.hset 'a_hash', 'my_key', '5'

        assert_equal 1, connection.hlen('a_hash')
        @hash_wrapper.remove('my_key')
        assert_equal 0, connection.hlen('a_hash')
      end

      def test_length
        assert_equal 0, @hash_wrapper.length

        connection.hset 'a_hash', 'my_key', '5'
        assert_equal 1, @hash_wrapper.length

        connection.hdel('a_hash', 'my_key')
        assert_equal 0, @hash_wrapper.length
      end
    end

    class QueueWrapperTest < LT::Test::RedisTestBase
      def setup
        super

        @queue_wrapper = Helpers::Redis::QueueWrapper.new(connection, 'a_queue')
      end

      def test_clear
        connection.lpush 'a_queue', 'my_msg'

        assert_equal 1, connection.llen('a_queue')
        @queue_wrapper.clear
        assert_equal 0, connection.llen('a_queue')
      end

       def test_push
         assert_nil connection.rpop('a_queue')
         @queue_wrapper.push('my_msg')
         assert_equal 'my_msg', connection.rpop('a_queue')
       end

       def test_pop
         assert_nil @queue_wrapper.pop
         connection.lpush('a_queue', 'my_msg')

         assert_equal 'my_msg', @queue_wrapper.pop
       end

       def test_length
         assert_equal 0, @queue_wrapper.length

         connection.lpush 'a_queue', 'my_msg'
         assert_equal 1, @queue_wrapper.length

         connection.rpop('a_queue')
         assert_equal 0, @queue_wrapper.length
       end
    end
  end
end
