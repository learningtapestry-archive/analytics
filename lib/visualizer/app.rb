# frozen_string_literal: true

module Analytics
  module Visualizer
    # entry point and API endpoints for the visualizer
    module App
      include LT::WebApp::Registerable

      registered do
        get '/visualizer' do
          erb :visualizer, views: 'lib/visualizer/views'
        end

        get '/visualizer/data' do
          content_type 'application/json'

          range = params['range'] || 'day'

          start_times = {
            'day' => 1.day.ago,
            'week' => 1.week.ago,
            'month' => 1.month.ago
          }

          halt 401, { error: 'Invalid date range' }.to_json unless start_times[range]

          recent_visits = Visit.where(date_visited: start_times[range]..Time.now).all

          return {
            totalVisitCount: Visit.count,
            recentVisits: recent_visits,
            recentVisitsByPage: recent_visits.group_by(&:page_id)
          }.to_json(include: :page)
        end
      end
    end
  end
end
