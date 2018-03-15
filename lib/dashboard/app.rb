# frozen_string_literal: true

module Analytics
  module Dashboard
    module App
      include LT::WebApp::Registerable

      # rubocop:disable Metrics/BlockLength
      registered do
        before do
          response.headers['Access-Control-Allow-Origin'] = '*'
          response.headers['Access-Control-Allow-Methods'] = 'GET, PUT, POST, DELETE'
          response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
        end

        # cors preflight request
        options '/data/overview' do
        end

        get '/data/overview' do
          authenticate_dashboard!(request.env['HTTP_AUTHORIZATION'])

          {
            total_visit_count: Visit.count,
            most_recent_visit_date: Visit.order(:date_visited).last&.date_visited
          }.to_json
        end

        # cors preflight request
        options '/data/visits_by_page' do
        end

        get '/data/visits_by_page' do
          authenticate_dashboard!(request.env['HTTP_AUTHORIZATION'])

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

        # cors preflight request
        options '/data/user_history' do
        end

        get '/data/user_history' do
          authenticate_dashboard!(request.env['HTTP_AUTHORIZATION'])

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
