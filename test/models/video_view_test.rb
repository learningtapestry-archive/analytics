require 'test_helper'

class VideoViewModelTest < LT::Test::DBTestBase
  def test_update_stats_on_playing_fills_the_start_date
    video_view = create_video_view

    video_view.update_stats(Time.now, 'playing')

    refute_nil video_view.date_started
  end

  def test_update_stats_on_playing_initializes_a_fragment_start_date
    video_view = create_video_view

    video_view.update_stats(Time.now, 'playing')

    refute_nil video_view.date_fragment_started
  end

  def test_update_stats_on_paused_updates_total_viewed_time
    video_view = create_video_view_with_a_fragment_started

    video_view.update_stats(Time.now, 'pause')

    assert_total_viewed_time_updated(video_view)
  end

  def test_video_view_update_stats_on_ended_fills_the_end_date
    video_view = create_video_view

    video_view.update_stats(Time.now, 'ended')

    refute_nil video_view.date_ended
  end

  def test_video_view_update_stats_on_ended_updates_total_viewed_time
    video_view = create_video_view_with_a_fragment_started

    video_view.update_stats(Time.now, 'ended')

    assert_total_viewed_time_updated(video_view)
  end

  private

  def create_video_view
    VideoView.create(session_id: 'A' * 36)
  end

  def create_video_view_with_a_fragment_started
    video_view = create_video_view
    origin = 3.seconds.ago
    video_view.update(date_started: origin, date_fragment_started: origin)
    video_view
  end

  def assert_total_viewed_time_updated(video_view)
    assert_equal 3.seconds, video_view.time_viewed
    assert_nil video_view.date_fragment_started
  end
end
