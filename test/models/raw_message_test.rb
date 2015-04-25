require 'test_helper'
require 'utils/scenarios'

class RawMessageModelTest < LT::Test::DBTestBase
  include Analytics::Utils::Scenarios::RawMessages

  def test_process_as_video_creates_videos_and_visits_if_they_dont_exist_yet
    create_video_message_and_process_it

    assert_equal [1, 1], [Video.count, VideoView.count]
  end

  def test_process_as_video_does_not_create_video_visit_if_it_already_exists
    2.times { create_video_message_and_process_it }

    assert_equal [1, 1], [Video.count, VideoView.count]
  end

  def test_process_as_video_marks_message_as_processed
    video_msg = create_video_message_and_process_it

    refute_nil video_msg.processed_at
  end

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

  private

  def create_video_message_and_process_it
    video_msg = RawMessage.create!(video)
    video_msg.process_as_video
    video_msg
  end
end
