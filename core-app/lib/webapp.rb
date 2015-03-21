require 'sinatra/base'
require 'sinatra/multi_route'
require 'sinatra/reloader'
require 'sinatra/cookies'
require 'sinatra/json'
require 'json'
require 'chronic'

require './lib/util/api_data_factory.rb'

module LT
  module WebAppHelper
    def set_title(title)
      @layout[:title] = "Learning Tapestry - #{title}"
    end
    def get_server_url
      # force https in production, otherwise mirror incoming request
      # we have to mirror incoming port in testing, b/c the port number is always changing
      if LT::production?
        scheme = "https"
        port = ""
      else
        scheme = request.scheme
        port = ":#{request.port.to_s}"
      end
      lt_api_server = "#{scheme}://#{request.host}#{port}"
    end

  end # WebAppHelper
  class WebApp < Sinatra::Base
    helpers Sinatra::Cookies
    helpers Sinatra::JSON
    use Rack::Session::Cookie, key: 'rack.session', secret: 'I3p3AIXG4ELYC77k'

    # TODO this is ugly - not sure how to get non-html exceptions raised in testing otherwise
    # There should be a way to get the config object from Sinatra/WebApp and configure that with these values
    if LT::testing?
      set :raise_errors, true
      set :dump_errors, false
      set :show_exceptions, false
    end
    if LT::development?
      register Sinatra::Reloader
      enable :reloader
      also_reload './lib/views/*.erb'
      # set this to prevent reloading of specific files
      # dont_reload '/path/to/other/file'
    end
    
    set :public_folder, LT::web_root_path

    Organization.update_all_org_api_keys
    
    include WebAppHelper

    API_ERROR_MESSAGE ||= { status: 'unknown error' }.to_json

    def allow_cross_domain_access
      response.headers['Access-Control-Allow-Origin'] = '*'
      response.headers['Access-Control-Allow-Methods'] = 'GET, PUT, POST, DELETE'
    end

    # set up UI layout container
    # we need this container to set dynamic content in the layout template
    # we can set things like CSS templates, Javascript includes, etc.
    before do
      @layout = {}
      allow_cross_domain_access
    end

    # This is used by js-collector testing to pull known page/data from server
    get '/test.html' do
      erb :test
    end

    ### END Dashboard

    # TODO make '/assets/tests/' only work dev/test environment?

    ### START API
    configure do
      mime_type :javascript, 'application/javascript'
    end

    get '/api/v1/service-status' do
      content_type :json

      redis_up = LT::RedisServer.ping
      hashlist_length = LT::RedisServer.api_key_hashlist_length
      org_api_key_hashlist_length = LT::RedisServer.org_api_key_hashlist_length
      raw_message_queue_length = LT::RedisServer.raw_message_queue_length

      database_up = LT::ping_db


      json({database: database_up,
            redis: redis_up,
            hashlist_length: hashlist_length,
            org_api_key_hashlist_length: org_api_key_hashlist_length,
            raw_message_queue_length: raw_message_queue_length,
            current_time: Time::now.to_s,
            env: LT::run_env})
    end

    get '/api/v1/common.js' do
      erb :'common.js', :layout=>false
    end

    # path to assert routes for org_api_key calls
    ORG_API_KEY_ASSERT_ROUTE = '/api/v1/assert-org'

    # Dynamically load js files based on parameter input
    # Creates Javascript pages based on incoming parameter input
    # TODO add /js/ into the path
    get '/api/v1/:page.js' do
      content_type :javascript
      username = params[:username]
      org_api_key = params[:org_api_key]
      # reject this request unless org_api_key is found in Redis
      if LT::RedisServer::org_api_key_get(org_api_key).nil?
        status 401
        return '// Invalid org_api_key'
      else
        lt_api_server = get_server_url
        locals = {
          org_api_key: CGI::escape(org_api_key),
          user_id: CGI::escape(username),
          assert_end_point: "#{lt_api_server}#{ORG_API_KEY_ASSERT_ROUTE}",
          lt_api_server: lt_api_server,
          autostart: false
        }
        # main selector to determine which javascript page to generate/send
        if params[:page] == 'collector' then
          erb :'collector.js', :layout => false, locals: locals
        elsif params[:page] == 'collector_video' then
          erb :'collector_video.js', :layout => false, locals: locals
        elsif params[:page] == 'loader' then
          # we are passed parameters to loader, asking which js pages
          # the loader should load async once it's booted. We pass
          # these files into the loader itself so that they will be loaded
          case params[:load]
            when 'collector'
              locals[:lt_api_libs] = ['collector']
            else
              status 401
              return '// Invalid loader parameters'
          end
          # instruct loader to auto-start if request asks for this
          locals[:autostart] = true if params[:autostart] == 'true'
          erb :'loader.js', :layout => false, locals: locals
        else
          status 401
          return '// Invalid page parameters'
        end
      end
    end

    get '/api/v1/approved-sites' do
      content_type :json
      ApprovedSite.get_all_with_actions.to_json
    end # '/api/v1/approved_sites

    # This route handles org_api_key assert messages
    #   '/api/v1/assert-org'
    get ORG_API_KEY_ASSERT_ROUTE do
      #content_type :javascript
      org_api_key = params[:oak]
      if !org_api_key.nil? && LT::RedisServer::has_org_api_key?(org_api_key)
        msg_string = params[:msg]
        LT::RedisServer.raw_message_push(msg_string.to_json)
        status 200
        return '{}'
      else
        status 401 
      end

    end


    post '/api/v1/assert' do
      begin
        api_key = request.env['HTTP_X_LT_API_KEY']
        if !api_key.nil? && !LT::RedisServer.api_key_get(api_key).nil?
          LT::RedisServer.raw_message_push(request.body.read)
          status 200 # = HTTP Success
        else
          status 401 # = HTTP Unauthorized
        end
      rescue Exception => e
        LT::logger.error "Unknown error in /api/v1/assert: #{e.message}"
        status 500
        API_ERROR_MESSAGE
      end
    end

    post '/api/v1/obtain' do
      content_type :json

      begin
        params = map_obtain_params(JSON.parse(request.body.read))

        if params[:org_api_key].nil? or params[:org_secret_key].nil?
          status 401 # = HTTP Unauthorized
          json error: 'Organization API key (org_api_key) and secret (org_secret_key) not provided'
        elsif params[:usernames].nil? or !params[:usernames].is_a?(Array) or params[:usernames].length == 0
          status 400 # = HTTP Bad Request
          json error: 'Username array (usernames) not provided'
        elsif params[:entity].nil?
          status 400 # = HTTP Bad Request
          json error: 'Entity type (entity) not provided'
        else
          org = Organization.find_by_org_api_key(params[:org_api_key])
          if !org or org.locked or !org.verify_secret(params[:org_secret_key])
            LT::logger.warn 'Invalid org_api_key submitted or locked: ' + params[:org_api_key]
            status 401 # = HTTP Unauthorized
            json error: 'org_api_key invalid or locked'
          else # We have a valid organization with validated secret and not locked out
              case params[:entity]
                when 'site_visits'
                  retval = LT::Utilities::APIDataFactory.site_visits(params)
                  status 200 # = HTTP Success
                when 'page_visits'
                  retval = LT::Utilities::APIDataFactory.page_visits(params)
                  status 200 # = HTTP Success
                else
                  LT::logger.warn "Unknown entity type in /api/v1/obtain, type: #{params[:entity]}"
                  status 400 # = HTTP Bad Request
                  retval = { error: "Unknown entity type: #{params[:entity]}" }
              end

              json retval
          end
        end
      rescue Exception => e
        LT::logger.error "Unknown error in /api/v1/obtain: #{e.message}"
        LT::logger.error "- Backtrace: #{e.backtrace}"
        status 500 # = HTTP Unknown Error
        API_ERROR_MESSAGE
      end
    end

    get '/api/v1/users' do
      if params[:org_api_key].nil? or params[:org_secret_key].nil?
        status 401 # = HTTP Unauthorized
        json error: 'Organization API key (org_api_key) and secret (org_secret_key) not provided'
      else
        begin
          retval = LT::Utilities::APIDataFactory.users(params[:org_api_key], params[:org_secret_key])
          status retval[:status]
        rescue Exception => e
          LT::logger.error "Unknown error in /api/v1/users: #{e.message}"
          LT::logger.error "- Backtrace: #{e.backtrace}"
          status 500 # = HTTP Unknown Error
          API_ERROR_MESSAGE
        end
        json retval
      end
    end

    get '/api/v1/video_views' do
      content_type :json
      if params[:org_api_key].nil? or params[:org_secret_key].nil?
        status 401 # = HTTP Unauthorized
        { error: 'Organization API key (org_api_key) and secret (org_secret_key) not provided' }.to_json
      else
        begin
          retval = LT::Utilities::APIDataFactory.video_visits(params)
          status 200
        rescue Exception => e
          LT::logger.error "Unknown error in /api/v1/video_views: #{e.message}"
          #LT::logger.error "- Backtrace: #{e.backtrace}"
          status 500 # = HTTP Unknown Error
          API_ERROR_MESSAGE
        end
      end
      retval
    end


    def map_obtain_params(http_params)
      retval = {}
      retval[:org_api_key] = http_params['org_api_key'] if http_params['org_api_key']
      retval[:org_secret_key] = http_params['org_secret_key'] if http_params['org_secret_key']
      retval[:usernames] = http_params['usernames'] if http_params['usernames']
      retval[:entity] = http_params['entity'] if http_params['entity']
      retval[:date_begin] = http_params['date_begin'] if http_params['date_begin']
      retval[:date_end] = http_params['date_end'] if http_params['date_end']
      retval[:site_domains] = http_params['site_domains'] if http_params['site_domains']
      retval[:page_urls] = http_params['page_urls'] if http_params['page_urls']
      retval[:type] = http_params['type'] if http_params['type']
      retval
    end

   ### END API
  end
end
