require 'test_helper'
require 'utils/scenarios'

class RawMessageModelTest < LT::Test::DBTestBase
  include Analytics::Utils::Scenarios::RawMessages

  def test_each_visit_scope_returns_proper_messages
    video_msg, page_msg = RawMessage.create!(video), RawMessage.create!(page)

    assert_equal [page_msg], RawMessage.page_msgs(100)
    assert_equal [video_msg], RawMessage.video_msgs(100)
  end

  def test_unprocessed_returns_only_messages_not_imported_yet
    unprocessed_msg = RawMessage.create!(unprocessed)
    RawMessage.create(processed)

    assert_equal [unprocessed_msg], RawMessage.unprocessed(100)
  end

  def test_unprocessed_returns_oldest_messages_first
    first_msg, last_msg = RawMessage.create!(old), RawMessage.create!(recent)

    assert_equal [first_msg, last_msg], RawMessage.unprocessed(100)
  end

  def test_unprocessed_can_return_a_specific_number_of_messages
    2.times { RawMessage.create!(unprocessed) }

    assert_equal 1, RawMessage.unprocessed(1).count
  end
end

class RawMessageProcessorTest < LT::Test::DBTestBase
  def setup
    super

    Organization.create!(org_api_key: raw_msg.org_api_key,
                         org_secret_key: SecureRandom.hex(36))
  end
end

class RawMessageProcessAsPageTest < RawMessageProcessorTest
  include Analytics::Utils::Scenarios::RawMessages

  def raw_msg
    @raw_msg ||= RawMessage.create!(page)
  end

  def test_process_as_page_when_page_does_not_exist_yet
    raw_msg.process_as_page

    assert_equal 1, Visit.count
    assert_visit_imported(Visit.first)
  end

  def test_process_as_page_when_page_already_exists
    Page.create!(url: raw_msg.url)

    raw_msg.process_as_page

    assert_equal 1, Visit.count
    assert_visit_imported(Visit.first)
  end

  def test_process_as_page_when_page_visit_is_a_different_one
    page = Page.create!(url: raw_msg.url)
    page.visits.create!(heartbeat_id: SecureRandom.hex(36))

    raw_msg.process_as_page

    assert_equal 2, Visit.count
    assert_visit_imported(Visit.last)
  end

  def test_process_as_page_when_page_visit_is_the_same
    page = Page.create!(url: raw_msg.url)
    page.visits.create!(heartbeat_id: raw_msg.heartbeat_id)

    raw_msg.process_as_page

    assert_equal 1, Visit.count
    assert_visit_imported(Visit.last)
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
    assert_equal raw_msg.heartbeat_id, visit.heartbeat_id
  end

  def assert_imported(page)
    assert_equal 1, Page.count
    assert_equal raw_msg.url, page.url
    assert_equal raw_msg.page_title, page.display_name
  end
end

class RawMessageProcessAsVideoTest < RawMessageProcessorTest
  include Analytics::Utils::Scenarios::RawMessages

  def raw_msg
    @raw_msg ||= RawMessage.create!(video)
  end

  def test_process_as_video_when_video_does_not_exist_yet
    raw_msg.process_as_video

    assert_equal 1, Visualization.count
    assert_visualization_imported(Visualization.first)
  end

  def test_process_as_video_when_video_exists
    Video.create!(url: raw_msg.action['video_id'])

    raw_msg.process_as_video

    assert_equal 1, Visualization.count
    assert_visualization_imported(Visualization.first)
  end

  def test_process_as_video_when_visualization_already_exists
    video = Video.create(url: raw_msg.action['video_id'])
    video.visualizations.create!(session_id: raw_msg.action['session_id'])

    raw_msg.process_as_video

    assert_equal 1, Visualization.count
    assert_visualization_imported(Visualization.first)
  end

  def test_process_as_video_marks_message_as_processed
    raw_msg.process_as_video

    refute_nil raw_msg.processed_at
  end

  private

  def assert_visualization_imported(visualization)
    assert_imported(visualization.video)

    assert_equal raw_msg.action['session_id'], visualization.session_id
    assert_equal raw_msg.url, visualization.page.url
    assert_equal raw_msg.username, visualization.user.username
  end

  def assert_imported(video)
    assert_equal 1, Video.count
    assert_equal raw_msg.action['video_id'], video.url
  end
end
