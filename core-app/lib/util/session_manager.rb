module LT
  module SessionManager
    class << self
      def validate_user(username, password)
        # Method will validate a user in the data model, if user is valid,
        # will create an API key in data model, then insert it into Redis

        if username.nil? || username.empty? || password.nil? || password.empty? then
          raise LT::ParameterMissing, "Username or password is not provided"
        else
          # TODO: Think about logic to re-use api key if session is already active
          retval = User.get_validated_user(username, password)
          exception = retval[:exception]
          raise exception unless exception.blank?
          user = retval[:user]
          api_key = ApiKey.create_api_key(user.id)
          LT::RedisServer.api_key_set(api_key, LT::get_db_name)
          return api_key
        end # if / else
      end # def ValidateUser
    end # class << self
  end # module SessionManager
end # module LT
