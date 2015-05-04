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

          Site.get_all_with_actions.to_json
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

        authenticated :obtain, :video_views, :users

        get vroute(:obtain) do
          filters = parse_visit_params(params)

          date_range = filters.slice(:date_begin, :date_end)
          entity = filters[:entity]

          summary = Visit.by_dates(*(date_range.values)).summary(entity)
          results = @org.users.joins(:visits).merge(summary)

          res = { entity: entity, date_range: date_range, results: results }

          [200, res.to_json]
        end

        get vroute(:video_views) do
          date_range = parse_date_range(params)

          report = Visualization.by_dates(*(date_range.values)).summary
          results = @org.users.joins(:visualizations).merge(report)

          [200, { date_range: date_range, results: results }.to_json]
        end

        get vroute(:users) do
          [200, @org.users.summary.to_json]
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
