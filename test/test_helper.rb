require 'lt/test'

require 'lt/core'
LT::Environment.boot_all(File.expand_path('../..', __FILE__))

require 'webapp'
Analytics::WebApp.boot

module Analytics
  module Test
    module Application
      def app
        WebApp
      end
    end

    class WebAppTestBase < LT::Test::WebAppTestBase
      include Application
    end

    class WebAppJSTestBase < LT::Test::WebAppJSTestBase
      include Application
    end
  end
end
