require 'redis'

module LT
  module RedisServer
    class << self
      def boot_redis(config_file)
        # Connect to Redis
        begin
          redis_config = YAML::load(File.open(config_file))
          redis_url = redis_config[LT::run_env]["url"]
          
          # Store static queue / hashlist names
          @queue_raw_message = redis_config[LT::run_env]["queue_raw_messages"]
          @hashlist_api_keys = redis_config[LT::run_env]["hashlist_api_keys"]
          @hashlist_org_api_keys = redis_config[LT::run_env]["hashlist_org_api_keys"]
          
          # Define and connect to server
          @redis = Redis.new(:url => @redis_url)
          @redis.ping # connect to Redis server
        rescue Exception => e
          # TODO: We shouldn't have to init logger here. This should be handled
          # by Rake bootup code of some kind or another. 
          # (In fact it may not be necessary - this might be redundant already.)
          LT::init_logger
          LT::logger.error("Cannot connect to Redis, connect url: #{@redis_url}, error: #{e.message}")
          raise e
        end
      end

      # raw messages

      def raw_messages_queue_clear
        @redis.del @queue_raw_message
      end

      def raw_message_push(message)
        @redis.lpush @queue_raw_message, message
      end

      def raw_message_pop
        @redis.rpop @queue_raw_message
      end

      def raw_message_queue_length
        @redis.llen @queue_raw_message
      end

      # api keys

      def api_keys_hashlist_clear
        @redis.del @hashlist_api_keys
      end

      def api_key_get(key)
        @redis.hget @hashlist_api_keys, key
      end

      def api_key_set(key, value)
        @redis.hset @hashlist_api_keys, key, value
      end

      def api_key_remove(key)
        @redis.hdel @hashlist_api_keys, key
      end

      def api_key_hashlist_length
        @redis.hlen @hashlist_api_keys
      end

      # org api keys
      # org api keys have an organization_id as value for an org_api_key key
      def org_api_keys_hashlist_clear
        @redis.del @hashlist_org_api_keys
      end

      def org_api_key_get(key)
        @redis.hget @hashlist_org_api_keys, key
      end

      def org_api_key_set(key, value)
        @redis.hset @hashlist_org_api_keys, key, value
      end

      def org_api_key_remove(key)
        @redis.hdel @hashlist_org_api_keys, key
      end

      def org_api_key_hashlist_length
        @redis.hlen @hashlist_org_api_keys
      end

    end
  end
end
