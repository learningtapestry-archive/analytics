require 'test_helper'

class VideoModelTest < LT::Test::DBTestBase
  def setup
    super

    @video = Video.create!(url: youtube_url)
  end

  def test_url_attr_writer_sets_url_field
    assert_equal youtube_url, @video.url
  end

  def test_url_attr_writer_sets_service_id
    assert_equal 'youtube', @video.service_id
  end

  def test_url_attr_writer_sets_external_id
    assert_equal 'VEi68CeE5eY', @video.external_id
  end

  def test_unprocessed_scope_returns_videos_without_a_title
    @video.update!(title: nil)

    assert_equal [@video], Video.unprocessed
  end

  def test_unprocessed_scope_does_not_return_videos_with_title
    @video.update!(title: 'Any')

    assert_empty Video.unprocessed
  end

  private

  def youtube_url
    'https://www.youtube.com/watch?src=manual&v=VEi68CeE5eY'
  end
end
