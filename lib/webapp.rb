# frozen_string_literal: true

require 'lt/webapp'
require 'dashboard/app'
require 'dashboard/helpers'

module Analytics
  class WebApp < LT::WebApp::Base
    helpers Helpers::Redis
    helpers Helpers::Authentication
    helpers Helpers::Params

    register Helpers::AuthenticationDSL
    register Routes::Api::V1
    register Routes::Api::V2

    helpers Helpers::Dashboard
    register Dashboard::App

    get '/' do
    end
  end
end
