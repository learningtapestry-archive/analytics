require 'sinatra'
require 'active_record'
require 'json'
require './lib/model/user.rb'
require './lib/lt_base.rb'

LT::run_env = "development"
LT::boot_db(File::expand_path('./db/config.yml'))

post '/api/v1/login' do
  begin
    begin
      parsed_json = JSON.parse(request.body.read)
      user = User.ValidateUser(parsed_json["username"], parsed_json["password"])
      status 200
      "{ ""username"": #{user.username} }"
    rescue Exception => e
      if e.is_a?(LT::UserNotFound) then
        status 401
        "Username not found"
      elsif e.is_a?(LT::PasswordInvalid)
        status 403
        "Invalid password"
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
      '{"status": "user created"}'
    else
      status 500
      '{"status": "error"}'
    end
  rescue Expection => e
    status 500
    "{""status"": ""#{e.message}""}"
  end
end