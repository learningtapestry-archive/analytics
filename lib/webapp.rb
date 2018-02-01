require 'lt/webapp'
require 'visualizer/app'

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
    register Visualizer::App

    get '/' do
    end
  end
end
