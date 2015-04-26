require 'test_helper'
require 'utils/scenarios'

class VideoModelTest < LT::Test::DBTestBase
  def test_url_attr_writer_sets_url_field
    assert_equal youtube_url, youtube_video.url
  end

  def test_url_attr_writer_sets_service_id
    assert_equal 'youtube', youtube_video.service_id
  end

  def test_url_attr_writer_sets_external_id
    assert_equal 'VEi68CeE5eY', youtube_video.external_id
  end

  private

  def youtube_url
    'https://www.youtube.com/watch?src=manual&v=VEi68CeE5eY'
  end

  def youtube_video
    Video.create!(url: youtube_url)
  end
end
