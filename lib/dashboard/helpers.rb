# frozen_string_literal: true

module Analytics
  module Helpers
    module Dashboard
      def recent_visits_by_user(visits)
        visits.map do |visit|
          {
            url: visit.page.url,
            date_visited: visit.date_visited,
            time_active: visit.time_active
          }
        end
      end
    end
  end
end
