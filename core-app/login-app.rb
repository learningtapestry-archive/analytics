require 'sinatra'
require 'active_record'
require 'json'
require './lib/util/session_manager.rb'
require './lib/lt_base.rb'

LT::run_env = ENV['RACK_ENV']
LT::boot_db(File::expand_path('./db/config.yml'))
LT::RedisServer.boot_redis(File::expand_path('./db/redis.yml'))

# TODO:  Set output type to application/json

post '/api/v1/login' do
  begin
    begin
      parsed_json = JSON.parse(request.body.read)
      api_key = LT::SessionManager.ValidateUser(parsed_json["username"], parsed_json["password"])
      #user = User.ValidateUser(parsed_json["username"], parsed_json["password"])
      status 200
      "{ ""status"": ""login success"", ""api-key"": ""#{api_key}"" }"
    rescue Exception => e
      if e.is_a?(LT::UserNotFound) || e.is_a?(LT::PasswordInvalid) then
        status 401 # 403 = unauthorized
        "{ ""status"": ""username or password invalid"" }"
      elsif
        status 500
        ##TODO:  Remove this after development
        e.message
      end
    end
  end
end

get '/api/v1/logout' do
  status 200
  '{"status": "logged out"}'
end

post '/api/v1/signup' do
  begin
    user = User.CreateUserFromJson(request.body.read)
    if user
      status 200
      # TODO: Return back API key as well
      "{ ""status"": ""user created"" }"
    else
      status 500
      '{"status": "error"}'
    end
  rescue Exception => e
    status 500
    "{""status"": ""#{e.message}""}"
  end
end