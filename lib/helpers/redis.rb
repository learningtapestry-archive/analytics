module Analytics
  module Helpers
    module Redis
      #
      # Manipulation of hash objects in Redis
      #
      class HashWrapper
        def initialize(redis, hash)
          @redis, @hash = redis, hash
        end

        def clear
          @redis.del @hash
        end

        def key?(key)
          !!get(key)
        end

        def get(key)
          @redis.hget @hash, key
        end

        def set(key, value)
          @redis.hset @hash, key, value
        end

        def remove(key)
          @redis.hdel @hash, key
        end

        def length
          @redis.hlen @hash
        end
      end

      #
      # Manipulation of queue objects in Redis
      #
      class QueueWrapper
        def initialize(redis, queue)
          @redis, @queue = redis, queue
        end

        def clear
          @redis.del @queue
        end

        def push(message)
          @redis.lpush @queue, message
        end

        def pop
          @redis.rpop @queue
        end

        def length
          @redis.llen @queue
        end
      end

      #
      # A hash-like object for api keys
      #
      def keys_hash
        @keys_hash ||=
          HashWrapper.new(LT.env.redis.connection, 'hashlist_api_keys')
      end

      #
      # A hash-like object for org api keys
      #
      def org_keys_hash
        @org_keys_hash ||=
          HashWrapper.new(LT.env.redis.connection, 'hashlist_org_api_keys')
      end

      #
      # A queue-like object for raw messages
      #
      def messages_queue
        @messages_queue ||=
          QueueWrapper.new(LT.env.redis.connection, 'queue_raw_messages')
      end
    end
  end
end
