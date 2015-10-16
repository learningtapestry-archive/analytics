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

  def test_summary_returns_visualizations_aggregated_by_video
    video = Video.create!(url: 'http://youtube.com?v=1')

    video.visualizations.create!(session_id: 'A' * 36)
    assert_equal 1, Visualization.summary.length

    video.visualizations.create!(session_id: 'A' * 36)
    assert_equal 1, Visualization.summary.length

    video2 = Video.create!(url: 'http://youtube.com?v=2')

    video2.visualizations.create!(session_id: 'A' * 36)
    assert_equal 2, Visualization.summary.length
  end

  def test_summary_returns_custom_columns
    attributes = { 'title' => 'Title',
                   'url' => 'http://youtube.com?v=1',
                   'publisher' =>' Entertaiment SA',
                   'video_length' => '00:00:37' }

    video = Video.create!(attributes)
    video.visualizations.create!(session_id: 'A' * 36)

    res = Visualization.summary

    assert_equal attributes, res.first.attributes.slice(*attributes.keys)
  end

  def test_summary_aggregates_total_viewed_time_by_video
    vid = Video.create!(url: 'http://youtube.com?v=1')
    2.times { vid.visualizations.create!(session_id: 'A' * 36, time_viewed: 3) }

    res = Visualization.summary

    assert_equal 6, res.first.attributes['time_viewed']
  end

  def test_by_dates_filters_visualizations_by_date
    visualizations = [Visualization.create(session_id: 'A' * 36, date_started: 1.week.ago, date_ended: 1.week.ago),
                      Visualization.create(session_id: 'B' * 36, date_started: 10.days.ago, date_ended: 10.days.ago)]

    assert_equal visualizations.first, Visualization.by_dates([1.week.ago.beginning_of_day], [Time.now]).first
    assert_equal visualizations, Visualization.by_dates([15.days.ago.beginning_of_day, 1.week.ago.beginning_of_day],
                                                        [9.days.ago.beginning_of_day, Time.now])
    assert_empty Visualization.by_dates([6.days.ago], [Time.now])
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
