require 'test_helper'
require 'utils/scenarios'

class RawMessageModelTest < LT::Test::DBTestBase
  include Analytics::Utils::Scenarios::RawMessages

  def test_each_visit_scope_returns_proper_messages
    video_msg, page_msg = RawMessage.create!(video), RawMessage.create!(page)

    assert_equal [page_msg], RawMessage.page_msgs
    assert_equal [video_msg], RawMessage.video_msgs
  end

  def test_unprocessed_returns_only_message_not_imported_yet
    unprocessed_msg = RawMessage.create!(unprocessed)
    RawMessage.create(processed)

    assert_equal [unprocessed_msg], RawMessage.unprocessed
  end

  def test_unprocessed_returns_oldest_messages_first
    first_msg, last_msg = RawMessage.create!(old), RawMessage.create!(recent)

    assert_equal [first_msg, last_msg], RawMessage.unprocessed
  end

  def test_unprocessed_can_return_a_specific_number_of_messages
    2.times { RawMessage.create!(unprocessed) }

    assert_equal 1, RawMessage.unprocessed(1).count
  end
end

class RawMessageProcessAsPageTest < LT::Test::DBTestBase
  include Analytics::Utils::Scenarios::RawMessages

  def raw_msg
    @raw_msg ||= RawMessage.create!(page)
  end

  def setup
    super

    Organization.create!(org_api_key: raw_msg.org_api_key)
  end

  def test_process_as_page_when_page_does_not_exist_yet
    raw_msg.process_as_page

    assert_equal 1, PageVisit.count
    assert_visit_imported(PageVisit.first)
  end

  def test_process_as_page_when_page_already_exists
    Page.create!(url: raw_msg.url)

    raw_msg.process_as_page

    assert_equal 1, PageVisit.count
    assert_visit_imported(PageVisit.first)
  end

  def test_process_as_page_when_page_visit_already_exists
    page = Page.create!(url: raw_msg.url)
    page.visits.create!

    raw_msg.process_as_page

    assert_equal 2, PageVisit.count
    assert_visit_imported(PageVisit.last)
  end

  def test_process_as_page_marks_message_as_processed
    raw_msg.process_as_page

    refute_nil raw_msg.processed_at
  end

  private

  def assert_visit_imported(visit)
    assert_imported(visit.page)

    assert_includes raw_msg.action['time'], visit.time_active.to_s
    assert_equal raw_msg.captured_at, visit.date_visited
    assert_equal raw_msg.username, visit.user.username
  end

  def assert_imported(page)
    assert_equal 1, Page.count
    assert_equal raw_msg.url, page.url
    assert_equal raw_msg.page_title, page.display_name
  end
end

class RawMessageProcessAsVideoTest < LT::Test::DBTestBase
  include Analytics::Utils::Scenarios::RawMessages

  def raw_msg
    @raw_msg ||= RawMessage.create!(video)
  end

  def setup
    super

    Organization.create!(org_api_key: raw_msg.org_api_key)
  end

  def test_process_as_video_when_video_does_not_exist_yet
    raw_msg.process_as_video

    assert_equal 1, VideoView.count
    assert_view_imported(VideoView.first)
  end

  def test_process_as_video_when_video_exists
    Video.create!(url: raw_msg.action['video_id'])

    raw_msg.process_as_video

    assert_equal 1, VideoView.count
    assert_view_imported(VideoView.first)
  end

  def test_process_as_video_when_view_already_exists
    video = Video.create(url: raw_msg.action['video_id'])
    video.views.create!(session_id: raw_msg.action['session_id'])

    raw_msg.process_as_video

    assert_equal 1, VideoView.count
    assert_view_imported(VideoView.first)
  end

  def test_process_as_video_marks_message_as_processed
    raw_msg.process_as_video

    refute_nil raw_msg.processed_at
  end

  private

  def assert_view_imported(view)
    assert_imported(view.video)

    assert_equal raw_msg.action['session_id'], view.session_id
    assert_equal raw_msg.url, view.page.url
    assert_equal raw_msg.username, view.user.username
  end

  def assert_imported(video)
    assert_equal 1, Video.count
    assert_equal raw_msg.action['video_id'], video.url
  end
end
