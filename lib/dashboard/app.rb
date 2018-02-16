# frozen_string_literal: true

module Analytics
  module Dashboard
    module App
      include LT::WebApp::Registerable

      registered do
        get '/data/visits_by_page' do
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
            includes(:page).
            all

          recent_visits_by_page(recent_visits).to_json
        end

        get '/data/overview' do
          {
            total_visit_count: Visit.count,
            most_recent_visit_date: Visit.first&.date_visited
          }.to_json
        end

        get '/data/user_history' do
          user = User.find_by(username: params[:user])

          halt 404, { error: 'User not found' }.to_json unless user

          user.to_json

          user.visits.order('id desc').last(10).to_json
        end
      end
    end
  end
end
