module Analytics
  module Visualizer
    module App
      include LT::WebApp::Registerable

      registered do
        get '/visualizer' do
          recentVisits = Visit.includes(:page).order('updated_at desc').first(1000)

          erb :visualizer, :views => 'lib/visualizer/views'
        end

        get '/visualizer/data' do
          content_type 'application/json'

          range = params['range'] || 'day'

          start_times = {
            'day' => 1.day.ago,
            'week' => 1.week.ago,
            'month' => 1.month.ago
          }

          halt 401, { :error => 'Invalid date range' }.to_json unless start_times[range]

          recentVisits = Visit.where(:date_visited => start_times[range]..Time.now).all

          {
            totalVisitCount: Visit.count,
            recentVisits: recentVisits,
            recentVisitsByPage: recentVisits.group_by(&:page_id)
          }.to_json(:include => :page)
        end
      end
    end
  end
end
