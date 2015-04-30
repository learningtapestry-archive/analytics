require 'test_helper'

require 'utils/youtube_adapter'

class YoutubeAdapterTest < LT::Test::DBTestBase
  def setup
    @video = Video.create!(url: 'https://www.youtube.com/watch?v=9bZkp7q19f0')

    Analytics::Utils::YoutubeAdapter.new(@video).import!
  end

  def test_correctly_imports_video_information
    assert_equal 'PSY - GANGNAM STYLE (강남스타일) M/V', @video.title
    assert_equal '00:04:13', @video.video_length
    assert @video.description.size > 10
    assert_equal 'officialpsy', @video.publisher
    assert_equal 'Music', @video.category
    assert @video.rating > 4.0, 'Rating must be higher than 4.0'
    assert @video.raters > 200000, 'Raters must be higher than 200000'
    assert_equal DateTime.parse('2012-07-15T07:46:32.000Z'), @video.published_on
    refute_nil @video.updated_on
  end
end
