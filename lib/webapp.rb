require 'lt/webapp'

require "skylight/sinatra"
Skylight.start!(file: 'config/skylight.yml')

module Analytics
  class WebApp < LT::WebApp::Base
    helpers Helpers::Redis
    helpers Helpers::Authentication
    helpers Helpers::Params

    register Helpers::AuthenticationDSL
    register Routes::Api::V1
    register Routes::Api::V2

    get '/' do
    end

    get '/visualizer' do
      visits = Visit.includes(:page).order('updated_at desc').first(1000)

      erb :visualizer,
        :views => 'lib/visualizer/views',
        :locals => {
          data: {
            visits: visits,
            visitsByPage: visits.group_by(&:page_id)
          }
        }
    end
  end
end
