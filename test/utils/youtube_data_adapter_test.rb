require 'test_helper'

require 'utils/youtube_data_adapter'

class YoutubeDataAdapterTest < LT::Test::DBTestBase
  def setup
    super

    @video = Video.create!(url: 'https://www.youtube.com/watch?v=9bZkp7q19f0')

    config = LT.env.load_optional_config('youtube.yml')
    Analytics::Utils::YoutubeDataAdapter.new(@video, config[:api_key]).import!
  end

  def test_correctly_imports_video_information
    assert_equal 'PSY - GANGNAM STYLE (강남스타일) M/V', @video.title
    assert @video.views > 2340830773
    assert_equal 'PT4M13S', @video.video_length
    assert @video.description.size > 10
    assert_equal 'officialpsy', @video.publisher
    assert_equal '10', @video.category
    refute_nil @video.rating
    refute_nil @video.raters
    assert_equal DateTime.parse('2012-07-15T07:46:32.000Z'), @video.published_on
    refute_nil @video.updated_on
  end
end
