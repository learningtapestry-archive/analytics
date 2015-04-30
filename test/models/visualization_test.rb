require 'test_helper'

class VisualizationModelTest < LT::Test::DBTestBase
  def test_update_stats_on_playing_fills_the_start_date
    visualization = Visualization.create(session_id: 'A' * 36)

    visualization.update_stats(Time.now, 'playing')

    refute_nil visualization.date_started
  end

  def test_update_stats_on_playing_initializes_a_fragment_start_date
    visualization = Visualization.create(session_id: 'A' * 36)

    visualization.update_stats(Time.now, 'playing')

    refute_nil visualization.date_fragment_started
  end

  def test_update_stats_on_paused_updates_total_visualizationed_time
    visualization = create_visualization_with_a_fragment_started

    visualization.update_stats(Time.now, 'pause')

    assert_total_viewed_time_updated(visualization)
  end

  def test_visualization_update_stats_on_ended_fills_the_end_date
    visualization = Visualization.create(session_id: 'A' * 36)

    visualization.update_stats(Time.now, 'ended')

    refute_nil visualization.date_ended
  end

  def test_visualization_update_stats_on_ended_updates_total_viewed_time
    visualization = create_visualization_with_a_fragment_started

    visualization.update_stats(Time.now, 'ended')

    assert_total_viewed_time_updated(visualization)
  end

  private

  def create_visualization_with_a_fragment_started
    visualization = Visualization.create(session_id: 'A' * 36)
    origin = 3.seconds.ago
    visualization.update(date_started: origin, date_fragment_started: origin)
    visualization
  end

  def assert_total_viewed_time_updated(visualization)
    assert_equal 3.seconds, visualization.time_viewed
    assert_nil visualization.date_fragment_started
  end
end
