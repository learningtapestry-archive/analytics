require 'test_helper'
require 'janitors/visit_extractor'
require 'janitors/extractor_tests'

class VisitExtractorTest < LT::Test::DBTestBase
  include ExtractorTests

  def setup
    super

    @raw_message = RawMessage.create!(page)
    @logger = TestLogger.new
    @target = Visit
    @extractor = VisitExtractor.new(@logger, 1)
  end

  def invalidate_raw_message
    @raw_message.update(url: nil)
  end
end
