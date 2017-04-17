require 'byebug'
require 'oj'

module Analytics
  module Routes
    module Api
      module V2
        include LT::WebApp::Registerable
        API_VERSION = 'v2'

        registered do
          #
          # Configuration
          #
          configure { mime_type :javascript, 'application/javascript' }

          #
          # Routes (All of them are preprended with '/api/vX')
          #
          routes = {
              service_status: 'service-status',
              common: 'common.js',
              approved_sites: 'approved-sites',
              assert_key: 'assert',
              assert_org_key: 'assert-org',
              sites: 'sites',
              pages: 'pages',
              users: 'users',
              video_views: 'video-views',
              page: ':page'
          }

          routes.each do |route, endpoint|
            vroute(route.to_sym, File.join('/api', API_VERSION, endpoint), true)
          end

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

            status = {database: LT.env.ping_db,
                      redis: LT.env.ping_redis,
                      hashlist_length: keys_hash.length,
                      org_api_key_hashlist_length: org_keys_hash.length,
                      raw_message_queue_length: messages_queue.length,
                      current_time: Time::now.to_s,
                      env: LT.env.run_env,
                      api_version: API_VERSION}

            status.to_json
          end

          get vroute(:common) do
            erb :'common.js', :layout => false
          end

          get vroute(:approved_sites) do
            content_type :json

            Site.get_all_with_actions.to_json
          end

          post vroute(:assert_key) do
            api_key = request.env['HTTP_X_LT_API_KEY']

            if api_key.present? && org_keys_hash.key?(api_key)
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

          authenticated :sites, :pages, :video_views, :users

          get vroute(:sites) do
            params[:entity] = 'site_visits'
            results = VisitsFacade.new(@org, parse_visit_params(params)).results

            [200, results.to_json]
          end

          get vroute(:pages) do
            params[:entity] = 'page_visits'
            results = VisitsFacade.new(@org, parse_visit_params(params)).results

            [200, Oj.dump(results, mode: :compat)]
          end

          get vroute(:video_views) do
            date_range = parse_date_ranges(params)
            usernames = parse_array_param(params[:usernames])

            report = Visualization.by_dates(*(date_range.values))
            report = report.by_usernames(usernames) if usernames.present?
            results = @org.users.joins(:visualizations).merge(report.summary)

            [200, {date_range: date_range, results: results}.to_json]
          end

          get vroute(:users) do
            [200, {results: @org.users.summary}.to_json]
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
                tracking_interval: (Integer(params[:tracking_interval]) rescue 60),
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
              locals[:autostart] = params[:autostart] == 'true'
              erb :'loader.js', layout: false, locals: locals
            else
              status 401
              json error: '// Invalid page parameters'
            end
          end
        end
      end
    end
  end
end
