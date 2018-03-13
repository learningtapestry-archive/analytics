# frozen_string_literal: true

module Analytics
  module Dashboard
    module App
      include LT::WebApp::Registerable

      # rubocop:disable Metrics/BlockLength
      registered do
        post '/data/overview' do
          authenticate!

          {
            total_visit_count: Visit.count,
            most_recent_visit_date: Visit.order(:date_visited).last&.date_visited
          }.to_json
        end

        post '/data/visits_by_page' do
          authenticate!

          content_type 'application/json'

          range = params['range'] || 'day'

          start_times = {
            'day' => 1.day.ago,
            'week' => 1.week.ago,
            'month' => 1.month.ago
          }

          halt 401, { error: 'Invalid date range' }.to_json unless start_times[range]

          visits = Visit.group_by_page(start_times[range]..Time.now)

          {}.tap do |hash|
            visits.map do |visit|
              hash[visit.attributes['url']] = visit.attributes['count']
            end
          end.to_json
        end

        post '/data/user_history' do
          authenticate!

          user = User.find_by(username: params[:user])

          if user
            visits = user.
              visits.
              order('id desc').
              includes(:page).
              last(20)

            recent_visits_by_user(visits).to_json
          else
            [].to_json
          end
        end
      end
      # rubocop:enable Metrics/BlockLength
    end
  end
end
