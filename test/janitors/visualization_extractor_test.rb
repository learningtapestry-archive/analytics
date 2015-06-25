require 'test_helper'
require 'janitors/visualization_extractor'
require 'janitors/extractor_tests'

class VisualizationExtractorTest < LT::Test::DBTestBase
  include ExtractorTests

  def setup
    super

    @raw_message = RawMessage.create!(video)
    @logger = TestLogger.new
    @target = Visualization
    @extractor = VisualizationExtractor.new(@logger, 1)
  end

  def invalidate_raw_message
    @raw_message.update(action: { video_id: nil })
  end
end
