test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

class VideoModelTest < LTDBTestBase

  def setup
    super
  end
  def teardown
    super
  end

  def test_create_youtube_videos_from_urls
    video = Video.find_or_create_by_url('https://www.youtube.com/watch?src=manual&v=VEi68CeE5eY')
    assert_equal LT::Constants::SERVICES_YOUTUBE, video.service_id
    assert_equal 'VEi68CeE5eY', video.external_id
    video.delete

    video = Video.find_or_create_by_url('http://www.youtube.com/watch?v=t96V-9f7Hd8&feature=youtube_gdata_player')
    assert_equal LT::Constants::SERVICES_YOUTUBE, video.service_id
    assert_equal 't96V-9f7Hd8', video.external_id
    video.delete
  end

end
