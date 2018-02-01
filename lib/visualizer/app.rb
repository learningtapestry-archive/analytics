# frozen_string_literal: true

module Analytics
  module Visualizer
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

          recent_visits = Visit.
            order('date_visited desc').
            where(date_visited: start_times[range]..Time.now).
            all

          {
            total_visit_count: Visit.count,
            most_recent_visit_date: Visit.first.date_visited,
            recent_visits_by_page: recent_visits_by_page(recent_visits.to_a)
          }.to_json
        end
      end
    end
  end
end
