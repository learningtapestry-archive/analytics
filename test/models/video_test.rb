require 'test_helper'
require 'utils/scenarios'

class VideoModelTest < LT::Test::DBTestBase
  include Analytics::Utils::Scenarios::RawMessages

  def test_url_attr_writer_sets_url_field
    assert_equal youtube_url, youtube_video.url
  end

  def test_url_attr_writer_sets_service_id
    assert_equal 'youtube', youtube_video.service_id
  end

  def test_url_attr_writer_sets_external_id
    assert_equal 'VEi68CeE5eY', youtube_video.external_id
  end

  def test_video_view_from_raw_message_creates_a_new_video_and_page
    video_msg, video_obj = create_raw_message_and_related_video
    video_obj.video_view_from_raw_message(video_msg)

    assert_equal [1, 1], [VideoView.count, Page.count]
  end

  def test_video_view_from_raw_message_updates_video_view_if_existing_session
    video_msg, video_obj = create_raw_message_and_related_video
    2.times { video_obj.video_view_from_raw_message(video_msg) }

    assert_equal [1, 1], [VideoView.count, Page.count]
  end

  def test_video_view_from_raw_message_does_not_create_page_if_no_url_provided
    video_msg, video_obj = create_raw_message_without_url_and_related_video

    video_obj.video_view_from_raw_message(video_msg)

    assert_equal [1, 0], [VideoView.count, Page.count]
  end

  #
  # TODO: This might need to be compulsory and to require validations
  #
  def video_view_from_raw_message_properly_links_to_user_if_info_provided
  end

  private

  def youtube_url
    'https://www.youtube.com/watch?src=manual&v=VEi68CeE5eY'
  end

  def youtube_video
    Video.create!(url: youtube_url)
  end

  def create_raw_message_and_related_video
    video_msg = RawMessage.create!(video)
    video_obj = Video.create!(url: video_msg.action['video_id'])

    [video_msg, video_obj]
  end

  def create_raw_message_without_url_and_related_video
    video_msg, video_obj = create_raw_message_and_related_video
    video_msg.update(url: nil)

    [video_msg, video_obj]
  end
end
