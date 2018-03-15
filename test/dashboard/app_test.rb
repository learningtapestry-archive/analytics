# frozen_string_literal: true

require 'test_helper'

module Analytics
  module Test
    class RawMessageImporterTest < WebAppTestBase
      def setup
        super

        user = User.create(username: 'testuser')
        page = Page.create(url: 'http://test.page')

        create_visit(user, page, Time.now)
        create_visit(user, page, 3.days.ago)
        create_visit(user, page, 8.days.ago)
      end

      def teardown
        super

        User.delete_all
        Page.delete_all
        Visit.delete_all
      end

      def create_visit(user, page, timestamp)
        Visit.create(
          user: user,
          page: page,
          heartbeat_id: SecureRandom.hex,
          date_visited: timestamp,
          created_at: timestamp,
          updated_at: timestamp
        )
      end

      def test_unauthorized_overview
        get '/data/overview'
        assert_equal(401, last_response.status)
      end

      def test_unauthorized_user_history
        get '/data/user_history'
        assert_equal(401, last_response.status)
      end

      def test_unauthorized_visits_by_page
        get '/data/visits_by_page'
        assert_equal(401, last_response.status)
      end

      def test_authorized_overview
        authorized_dashboard_request do
          get '/data/overview'
        end

        assert_equal(200, last_response.status)

        response = JSON.parse(last_response.body)

        assert_equal(3, response['total_visit_count'])
        assert_equal(Date.today, Date.parse(response['most_recent_visit_date']))
      end

      def test_authorized_user_history
        authorized_dashboard_request do
          get '/data/user_history?user=testuser'
        end

        assert_equal(200, last_response.status)

        response = JSON.parse(last_response.body)

        assert_equal(3, response.length)
      end

      def fetch_visits_by_page(range)
        authorized_dashboard_request do
          get "/data/visits_by_page?range=#{range}"
        end

        assert_equal(200, last_response.status)

        JSON.parse(last_response.body)
      end

      def test_authorized_visits_by_page
        assert_equal(1, fetch_visits_by_page('day').values.first)
        assert_equal(2, fetch_visits_by_page('week').values.first)
        assert_equal(3, fetch_visits_by_page('month').values.first)
      end

      def authorized_dashboard_request
        dashboard = ::Dashboard.create(name: 'Test dashboard')
        header 'Authorization', "Token #{dashboard.auth_token.value}"
        yield
        ::Dashboard.delete_all
      end
    end
  end
end
