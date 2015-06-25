require 'test_helper'

require 'janitors/video_metadata_extractor'

class VideoMetadataExtractorTest < LT::Test::DBTestBase
  def setup
    super

    @video = Video.create!(url: 'https://www.youtube.com/watch?v=9bZkp7q19f0')

    @logger = TestLogger.new
    config = LT.env.load_file_config('youtube.yml')
    @extractor = Analytics::Janitors::VideoMetadataExtractor.new(@logger, 1, config)
  end

  def test_grabs_metadata_from_youtube_for_videos_without_title
    @extractor.extract

    refute_nil @video.reload.views
  end

  def test_does_not_grab_any_data_for_videos_with_set_title
    @video.update!(title: 'Already filled')
    @extractor.extract

    assert_nil @video.reload.views
  end

  def test_logs_stats
    @extractor.extract

    assert_includes @logger.debug_output.string, '1 processed / 0 failures'
  end
end
