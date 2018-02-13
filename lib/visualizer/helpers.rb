# frozen_string_literal: true

module Analytics
  module Helpers
    module Visualizer
      def recent_visits_by_page(recent_visits)
        recent_visits_by_page = {}

        recent_visits.each do |visit|
          recent_visits_by_page[visit.page.url] ||= 0
          recent_visits_by_page[visit.page.url] += 1
        end

        recent_visits_by_page
      end
    end
  end
end
