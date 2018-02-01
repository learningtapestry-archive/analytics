# frozen_string_literal: true

module Analytics
  module Helpers
    module Visualizer
      def recent_visits_by_page(recent_visits)
        recent_visits_by_page = {}

        recent_visits.map(&:page).map(&:url).uniq.each do |url|
          recent_visits_by_page[url] = recent_visits.count do |visit|
            visit.page.url == url
          end
        end

        recent_visits_by_page
      end
    end
  end
end
