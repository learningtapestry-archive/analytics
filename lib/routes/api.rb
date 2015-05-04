module Analytics
  module Routes
    module Api
      include LT::WebApp::Registerable

      registered do
        #
        # Configuration
        #
        configure { mime_type :javascript, 'application/javascript' }

        #
        # Routes
        #
        vroute(:service_status, '/api/v1/service-status')
        vroute(:common, '/api/v1/common.js')
        vroute(:approved_sites, '/api/v1/approved-sites')
        vroute(:assert_key, '/api/v1/assert')
        vroute(:assert_org_key, '/api/v1/assert-org')
        vroute(:obtain, '/api/v1/obtain')
        vroute(:users, '/api/v1/users')
        vroute(:video_views, '/api/v1/video_views')
        vroute(:page, '/api/v1/:page')

        #
        # TODO: Move this somewhere else. When is this supposed to be run?
        #
        # Organization.update_all_org_api_keys

        #
        # Before filters
        #
        before do
          response.headers['Access-Control-Allow-Origin'] = '*'
          response.headers['Access-Control-Allow-Methods'] = 'GET, PUT, POST, DELETE'
        end

        # This is used by js-collector testing to pull known page/data from server
        get /test.html/ do
          erb :test
        end

        #
        # API actions
        #
        get vroute(:service_status) do
          content_type :json

          status = { database: LT.env.ping_db,
                     redis: LT.env.ping_redis,
                     hashlist_length: keys_hash.length,
                     org_api_key_hashlist_length: org_keys_hash.length,
                     raw_message_queue_length: messages_queue.length,
                     current_time: Time::now.to_s,
                     env: LT.env.run_env }

          status.to_json
        end

        get vroute(:common) do
          erb :'common.js', :layout=>false
        end

        get vroute(:approved_sites) do
          content_type :json

          ApprovedSite.get_all_with_actions.to_json
        end

        post vroute(:assert_key) do
          api_key = request.env['HTTP_X_LT_API_KEY']

          if !api_key.nil? && keys_hash.key?(api_key)
            messages_queue.push(request.body.read)
            status 200 # = HTTP Success
          else
            status 401 # = HTTP Unauthorized
          end
        end

        get vroute(:assert_org_key) do
          if !params[:oak].nil? && org_keys_hash.key?(params[:oak])
            messages_queue.push(params[:msg].to_json)
            status 200
            return '{}'
          else
            status 401
          end
        end

        post vroute(:obtain) do
          content_type :json

          # Get a key valued params hash from request's body
          # NOTE: If we start needing this in more places, consider using
          # rack-contrib's Rack::PostBodyContentTypeParser
          params = \
            JSON.parse(request.body.read).map { |k, v| [k.to_sym, v] }.to_h

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
              LT.env.logger.warn 'Invalid org_api_key submitted or locked: ' + params[:org_api_key]
              status 401 # = HTTP Unauthorized
              json error: 'org_api_key invalid or locked'
            else # We have a valid organization with validated secret and not locked out
              case params[:entity]
              when 'site_visits'
                retval = site_visits(params)
                status 200 # = HTTP Success
              when 'page_visits'
                retval = page_visits(params)
                status 200 # = HTTP Success
              else
                LT.env.logger.warn "Unknown entity type in /api/v1/obtain, type: #{params[:entity]}"
                retval = { error: "Unknown entity type: #{params[:entity]}" }
                status 400 # = HTTP Bad Request
              end

              json retval
            end
          end
        end

        get vroute(:users) do
          content_type :json

          if params[:org_api_key].nil? or params[:org_secret_key].nil?
            status 401 # = HTTP Unauthorized
            json error: 'Organization API key (org_api_key) and secret (org_secret_key) not provided'
          else
            retval = users(params[:org_api_key], params[:org_secret_key])
            status retval[:status]
            json retval
          end
        end

        get vroute(:video_views) do
          content_type :json

          if params[:org_api_key].nil? or params[:org_secret_key].nil?
            retval = { error: 'Organization API key (org_api_key) and secret (org_secret_key) not provided' }.to_json
            status 401 # = HTTP Unauthorized
          else
            retval = video_visits(params)
            status 200
          end

          retval
        end

        # Creates Javascript pages based on incoming parameter input
        # TODO add /js/ into the path
        get vroute(:page) do
          content_type :javascript

          org_key = params[:org_api_key]

          # Reject this request unless org_api_key is found in Redis
          halt 401, '// Invalid org_api_key' unless org_keys_hash.key?(org_key)

          # Reject this request unless a username is provided
          halt 400, '// Misssing username' unless params[:username].present?

          api_server = get_server_url

          locals = {
            org_api_key: CGI::escape(org_key),
            user_id: CGI::escape(params[:username]),
            assert_end_point: "#{api_server}#{vroute(:assert_org_key)}",
            lt_api_server: api_server,
            autostart: false
          }

          # main selector to determine which javascript page to generate/send
          if params[:page] == 'collector.js' then
            erb :'collector.js', layout: false, locals: locals
          elsif params[:page] == 'collector_video.js' then
            erb :'collector_video.js', layout: false, locals: locals
          elsif params[:page] == 'loader.js' then
            # we are passed parameters to loader, asking which js pages
            # the loader should load async once it's booted. We pass
            # these files into the loader itself so that they will be loaded
            case params[:load]
            when 'collector'
              locals[:lt_api_libs] = ['collector', 'collector_video']
            else
              status 401
              json error: '// Invalid loader parameters'
            end
            # instruct loader to auto-start if request asks for this
            locals[:autostart] = true if params[:autostart] == 'true'
            erb :'loader.js', :layout => false, locals: locals
          else
            status 401
            json error: '// Invalid page parameters'
          end
        end
      end
    end
  end
end
