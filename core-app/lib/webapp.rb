require 'sinatra/base'
#require 'sinatra/contrib'
require 'sinatra/multi_route'
require 'sinatra/reloader'
require 'sinatra/cookies'
require 'json'
require 'chronic'
require 'pry'
require File::join(LT::lib_path, 'util', 'session_manager.rb')
require File::join(LT::lib_path, 'util', 'redis_server.rb')

module LT
  module WebAppHelper
    def set_title(title)
      @layout[:title] = "Learning Tapestry - #{title}"
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
    if LT::development? then
      register Sinatra::Reloader
      enable :reloader
      also_reload './lib/views/*.erb'
      # set this to prevent reloading of specific files
      # dont_reload '/path/to/other/file'
    end
    
    set :public_folder, LT::web_root_path
    
    include WebAppHelper

    API_ERROR_MESSAGE ||= { :status => "unknown error" }.to_json

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
        erb :home, locals: {page_title: "Welcome", exception: user_retval[:exception], extension_login: (params[:src] == "ext")}, layout: :layout_noauth 
      else
        session[:user_id] = user_retval[:user].id

        # If the source is the extension, then set a cookie for the extension long-lived session  
        if params[:src] == "ext" then
          user = user_retval[:user]
          api_key = ApiKey.create_api_key(user.id)
          response.set_cookie('api_key', httponly: true, value: "#{api_key}.#{user.id}.#{user.first_name}")
        end

        redirect '/dashboard'
      end
    end

    dashboard = lambda do
      if !session || !session[:user_id] then redirect '/' end
      set_title("Your Dashboard")
      user = User.find(session[:user_id])
      begin_date = params[:begin_date] || Time.now.strftime("%D")
      end_date = params[:end_date] || Time.now.strftime("%D")
      erb :dashboard, locals: { page_title: "Dashboard", user: user, begin_date: begin_date, end_date: end_date }
    end

    get "/dashboard", &dashboard
    post "/dashboard", &dashboard

    get "/welcome" do
      erb :welcome, locals: { page_title: "Welcome!" }, layout: :layout_noauth
    end

    get "/privacy" do
      erb :privacy, locals: { page_title: "Privacy" }, layout: :layout_noauth
    end

    ### END Dashboard

    # TODO make '/assets/tests/' only work dev/test environment?

    ### START API
    configure do
      mime_type :javascript, 'application/javascript'
    end

    get '/api/v1/common.js' do
      erb :"common.js", :layout=>false
    end

    ORG_API_KEY_ASSERT_ROUTE = "/api/v1/assert-org"
    # this is a dynamically rendered js file
    get '/api/v1/collector.js' do
      content_type :javascript
      username = params[:username]
      org_api_key = params[:org_api_key]
      # reject this request unless org_api_key is found in Redis
      if LT::RedisServer::org_api_key_get(org_api_key).nil? then
        status 401
        return
      else
        locals = {
          org_api_key: org_api_key,
          user_id: username,
          assert_end_point: ORG_API_KEY_ASSERT_ROUTE
        }
        erb :"collector.js", :layout => false, locals: locals
      end
    end

    get '/api/v1/approved-sites' do
      content_type :json
      ApprovedSite.get_all_with_actions.to_json
    end # '/api/v1/approved_sites

    # This route handles org_api_key assert messages
    # e.g., /api/v1/assert-org
    post ORG_API_KEY_ASSERT_ROUTE do
      org_api_key = request.env["HTTP_X_LT_ORG_API_KEY"]
      if !org_api_key.nil? && LT::RedisServer::has_org_api_key?(org_api_key)
        LT::RedisServer.raw_message_push(request.body.read)
        status 200
      else
        status 401 
      end

    end


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

