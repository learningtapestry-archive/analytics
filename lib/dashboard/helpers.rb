# frozen_string_literal: true

module Analytics
  module Helpers
    module Dashboard
      def recent_visits_by_page(recent_visits)
        recent_visits_by_page = {}

        recent_visits.each do |visit|
          recent_visits_by_page[visit.page.url] ||= 0
          recent_visits_by_page[visit.page.url] += 1
        end

        recent_visits_by_page
      end

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
