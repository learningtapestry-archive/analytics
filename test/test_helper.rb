require 'lt/test'

require 'lt/core'
LT::Environment.boot_all(Dir.pwd, 'test')

require 'webapp'
Analytics::WebApp.boot

class TestLogger
  attr_reader :debug_output

  def initialize
    @debug_output = StringIO.new
  end

  def debug(msg)
    @debug_output.puts(msg)
  end
end

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
