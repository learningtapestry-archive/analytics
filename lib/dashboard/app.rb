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

          visits = Visit.
            select('url, count(*)').
            from(Visit.
              select('*').
              where(date_visited: start_times[range]..Time.now).
              joins(:page)).
            group(:url).
            all

          {}.tap do |hash|
            visits.map do |visit|
              hash[visit.attributes['url']] = visit.attributes['count']
            end
          end.to_json
        end

        get '/data/overview' do
          {
            total_visit_count: Visit.count,
            most_recent_visit_date: Visit.first&.date_visited
          }.to_json
        end

        get '/data/user_history' do
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
    end
  end
end