require 'lt/webapp'

module Analytics
  class WebApp < LT::WebApp::Base
    helpers Helpers::Redis
    helpers Helpers::APIDataFactory

    register Routes::Api
  end
end
