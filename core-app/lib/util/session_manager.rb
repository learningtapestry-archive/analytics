require "./lib/model/user.rb"
require "./lib/model/api_key.rb"
require "./lib/util/redis_server.rb"

module LT
  module SessionManger
    class << self
      def self.ValidateUser(username, password)
        # Method will validate a user in the data model, if user is valid,
        # will create an API key in data model, then insert it into Redis

        begin
          user = User.ValidateUser(username, password)
          api_key = ApiKey.GetApiKey(user.id)
          LT::RedisServer::boot_redis(File::expand_path('./db/redis.yml'))
          LT::RedisServer.api_key_set(api_key, queue_name)
          return api_key
        rescue Exception => e
          raise e        
        end
      end
    end
  end
end
