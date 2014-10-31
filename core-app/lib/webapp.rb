require 'sinatra/base'
require 'sinatra/multi_route'
require 'sinatra/reloader'
require 'sinatra/cookies'
require 'sinatra/json'
require 'json'
require 'chronic'

module LT
  module WebAppHelper
    def set_title(title)
      @layout[:title] = "Learning Tapestry - #{title}"
    end
  end # WebAppHelper
  class WebApp < Sinatra::Base
    helpers Sinatra::Cookies
    helpers Sinatra::JSON
    use Rack::Session::Cookie, key: "rack.session", secret: "I3p3AIXG4ELYC77k"

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

    API_ERROR_MESSAGE ||= { status: 'unknown error' }.to_json

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

    # Routes for dashboard defined as GET and POST below
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

    # This is used by js-collector testing to pull known page/data from server
    get "/test.html" do
      erb :test, layout: :layout_noauth
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

    # path to assert routes for org_api_key calls
    ORG_API_KEY_ASSERT_ROUTE = "/api/v1/assert-org"

    # Dynamically load js files based on parameter input
    # Creates Javascript pages based on incoming parameter input
    # TODO add /js/ into the path
    get '/api/v1/:page.js' do
      content_type :javascript
      username = params[:username]
      org_api_key = params[:org_api_key]
      # reject this request unless org_api_key is found in Redis
      if LT::RedisServer::org_api_key_get(org_api_key).nil? then
        status 401
        return
      else
        # force https in production, otherwise mirror incoming request
        if LT::production? then
          scheme = "https"
        else
          scheme = request.scheme
        end
        lt_api_server = "#{scheme}://#{request.host}:#{request.port.to_s}"
        locals = {
          org_api_key: CGI::escape(org_api_key),
          user_id: CGI::escape(username),
          assert_end_point: "#{lt_api_server}#{ORG_API_KEY_ASSERT_ROUTE}",
          lt_api_server: lt_api_server
        }
        # main selector to determine which javascript page to generate/send
        if params[:page] == 'collector' then
          erb :"collector.js", :layout => false, locals: locals
        elsif params[:page] == 'loader' then
          # we are passed parameters to loader, asking which js pages
          # the loader should load async once it's booted. We pass
          # these files into the loader itself so that they will be loaded
          case params[:load]
            when "collector"
              locals[:lt_api_libs] = ["collector"]
            else
              status 401
              return
          end
          # instruct loader to auto-start if request asks for this
          locals[:autostart] = true if params[:autostart] == "true"
          erb :"loader.js", :layout => false, locals: locals
        else
          status 401
          return
        end
      end
    end

    get '/api/v1/approved-sites' do
      content_type :json
      ApprovedSite.get_all_with_actions.to_json
    end # '/api/v1/approved_sites

    # This route handles org_api_key assert messages
        "/api/v1/assert-org"
    get ORG_API_KEY_ASSERT_ROUTE do
      org_api_key = params[:oak]
      if !org_api_key.nil? && LT::RedisServer::has_org_api_key?(org_api_key)
        msg_string = params[:msg]
        LT::RedisServer.raw_message_push(msg_string.to_json)
        status 200
        return " "
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

    post '/api/v1/obtain' do
      ##TODO:  Determine where to model this, I feel as if it is a query factory assembling dev-friendly JSON;
      ##       Steve may want to include in model objects themselves.

      ## Starter code below

      body_params = JSON.parse request.body.read

      if body_params['org_api_key'].nil? then
        status 401 # = HTTP unauthorized
        json status: 'Organization API key (org_api_key) not provided'
      elsif body_params['usernames'].nil? or !body_params['usernames'].is_a?(Array) or body_params['usernames'].length == 0
        status 400
        json status: 'Username list (usernames) not provided'
      else
        org_api_key = body_params['org_api_key']
        usernames = body_params['usernames']

        if body_params['filters'] then
          begin_date = body_params['filters']['begin_date'] ? body_params['filters']['begin_date'] : Time::now - 7.days  # default on returning last week's of data
          end_date = body_params['filters']['end_date'] || Time::now
        end

        site_visits = Site
        .select(User.arel_table[:username])
        .select(Site.arel_table[:display_name])
        .select(Site.arel_table[:url])
        .select(PageVisit.arel_table[:time_active].sum.as('time_active'))
        .joins('JOIN pages ON pages.site_id = sites.id')
        .joins('JOIN page_visits ON page_visits.page_id = pages.id')
        .joins('JOIN users ON users.id = page_visits.user_id')
        .joins('JOIN organizations ON organizations.id = users.organization_id')
        .where(['page_visits.date_visited BETWEEN SYMMETRIC ? and ?', begin_date, end_date])
        .where(User.arel_table[:username].in(usernames))
        .where(['organizations.org_api_key = ?', org_api_key])
        .group(User.arel_table[:username])
        .group(Site.arel_table[:display_name])
        .group(Site.arel_table[:url])
        .order(User.arel_table[:username])

        retval = { results: [] }
        username = nil
        username_count = -1
        ## Create a JSON structure organized by username with each site visit
        site_visits.each do |site_visit|
          if username != site_visit[:username] then
            username = site_visit[:username]
            username_count += 1
            retval[:results].push({ username: username })
            retval[:results][username_count][:site_visits] = []
          end
          array = []
          retval[:results][username_count][:site_visits].push(
              {display_name: site_visit[:display_name],
              url: site_visit[:url],
              time_active: site_visit[:time_active]})
        end
        json retval
      end
    end

   ### END API
  end
end
