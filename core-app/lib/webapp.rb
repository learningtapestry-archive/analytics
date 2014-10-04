require 'sinatra/base'
#require 'sinatra/contrib'
require 'sinatra/cookies'
require 'json'
require File::join(LT::lib_path, 'util', 'session_manager.rb')
require File::join(LT::lib_path, 'util', 'redis_server.rb')

module LT
  module WebAppHelper
    def set_title(title)
      @layout[:title] = "Learntaculous - #{title}"
    end
  end # WebAppHelper
  class WebApp < Sinatra::Base
    helpers Sinatra::Cookies
    enable :sessions

    # TODO this is ugly - not sure how to get non-html exceptions raised in testing otherwise
    # There should be a way to get the config object from Sinatra/WebApp and configure that with these values
    if LT::testing? then
      set :raise_errors, true
      set :dump_errors, false
      set :show_exceptions, false
    end

    include WebAppHelper

    API_ERROR_MESSAGE = { :status => "unknown error" }.to_json
    # set up UI layout container
    # we need this container to set dynamic content in the layout template
    # we can set things like CSS templates, Javascript includes, etc.
    before do
      @layout = {}
    end

    ### START Dashboard

    get "/" do
      set_title("Knowledge for Learning")
      erb :home, locals: { page_title: "Welcome", extension_login: (params[:src] == "ext") }, layout: :layout_noauth
      # This is the only page that does not use the default layout
    end

    post "/" do
      set_title("Knowledge for Learning")
      user_retval = User.get_validated_user(params[:username], params[:password])

      if user_retval[:exception] then
        erb :home, locals: {page_title: "Welcome", exception: user[:exception]}, layout: :layout_noauth 
      else
        session[:user_id] = user_retval[:user].id

        # If the source is the extension, then set a cookie for the extension long-lived session  
        if params[:src] == "ext" then
          response.set_cookie('api_key', httponly: true, value: ApiKey.create_api_key(user_retval[:user].id).to_s + "." + user_retval[:user].id.to_s + "." + user_retval[:user].first_name)
        end

        redirect '/dashboard'
      end
    end

    get "/dashboard" do
      if !session || !session[:user_id] then redirect '/' end
      set_title("Your Dashboard")
      user = User.find(session[:user_id])
      erb :dashboard, locals: { page_title: "Dashboard", user: user }
    end

    get "/welcome" do
      erb :welcome, locals: { page_title: "Welcome!" }, layout: :layout_noauth
    end

    get "/privacy" do
      erb :privacy, locals: { page_title: "Privacy" }, layout: :layout_noauth
    end

    ### END Dashboard

    ### START API

    post '/api/v1/login' do
      content_type :json
      begin
        begin
          parsed_json = JSON.parse(request.body.read)
          api_key = LT::SessionManager.validate_user(parsed_json["username"], parsed_json["password"])
          status 200
          { :status => "login success", :api_key => api_key }.to_json
        rescue Exception => e
          if e.is_a?(LT::UserNotFound) then
            status 401 # = HTTP unauthorized
            { :status => 'username invalid' }.to_json          
          elsif e.is_a?(LT::PasswordInvalid) then
            status 401 # = HTTP unauthorized
            { :status => 'password invalid' }.to_json
          elsif
            status 500
            LT::logger.error "Unknown error in /api/v1/login: #{e.message}"
            API_ERROR_MESSAGE
          end
        end
      end
    end # '/api/v1/login'

    get '/api/v1/logout' do
      content_type :json
      status 501
      { status: "logged out not yet implemented" }.to_json
    end # '/api/v1/logout'

    post '/api/v1/signup' do
      content_type :json
      begin
        user = User.create_user_from_json(request.body.read)
        if user
          status 200
          # TODO: Return back API key as well
          { status: "user created" }.to_json
        else
          status 500
          LT::logger.error "User not returned in /api/v1/signup"
          API_ERROR_MESSAGE
        end
      rescue Exception => e
        status 500
        LT::logger.error "Unknown error in /api/v1/signup: #{e.message}"
        API_ERROR_MESSAGE
      end
    end # '/api/v1/signup'

    get '/api/v1/approved-sites' do
      # TODO:  Note this will be replaced with below once new extension is ready
      content_type :json
      ApprovedSiteAction.get_actions_with_sites.to_json
    end # '/api/v1/approved_sites'

    get '/api/v1/approved-sites-new' do
      # TODO:  Note this will replace above once new extension is ready
      content_type :json
      ApprovedSite.get_all_with_actions.to_json
    end # '/api/v1/approved_sites

    post '/api/v1/assert' do
      begin
        api_key = request.env["HTTP_X_LT_API_KEY"] 
        if !api_key.nil? && !LT::RedisServer.api_key_get(api_key).nil?
          LT::RedisServer.raw_message_push(request.body.read)
          status 200
        else
          status 401 # = HTTP unauthorized
        end
      rescue Exception => e
        status 500
        LT::logger.error "Unknown error in /api/v1/assert: #{e.message}"
        API_ERROR_MESSAGE
      end
    end

    ### END API
  end
end

