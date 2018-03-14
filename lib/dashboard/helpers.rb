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

      def authenticate_dashboard!(authorization_header)
        token = authorization_header&.split&.last
        unauthorized('Authorization token not provided') unless token

        dashboard = ::Dashboard.find_by_token(token)
        unauthorized('Unknown dashboard authorization token') unless dashboard
      end

      private

      def unauthorized(msg)
        halt(401, json(error: msg))
      end
    end
  end
end
