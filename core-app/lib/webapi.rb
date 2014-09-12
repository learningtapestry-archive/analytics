require 'sinatra/base'
require 'json'
require File::join(LT::lib_path, 'util', 'session_manager.rb')

module LT
  class WebApp < Sinatra::Base 

    before do
      content_type :json
    end

    post '/api/v1/login' do
      begin
        begin
          parsed_json = JSON.parse(request.body.read)
          api_key = LT::SessionManager.validate_user(parsed_json["username"], parsed_json["password"])
          status 200
          { :status => "login success", :api_key => api_key }.to_json
        rescue Exception => e
          if e.is_a?(LT::UserNotFound) || e.is_a?(LT::PasswordInvalid) then
            status 401 # 403 = unauthorized
            { :status => 'username or password invalid' }.to_json
          elsif
            status 500
            # TODO:  Remove this after development
            { :status => e.message }.to_json
          end
        end
      end
    end

    get '/api/v1/logout' do
      status 501
      { :status => "logged out not yet implemented" }.to_json
    end

    post '/api/v1/signup' do
      begin
        user = User.create_user_from_json(request.body.read)
        if user
          status 200
          # TODO: Return back API key as well
          { :status => "user created" }.to_json
        else
          status 500
          { :status => "error" }.to_json
        end
      rescue Exception => e
        status 500
        # TODO:  Remove this after development
        { :status => e.message }.to_json
      end
    end
  end
end