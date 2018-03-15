# frozen_string_literal: true

require 'test_helper'

module Analytics
  module Test
    class RawMessageImporterTest < WebAppTestBase
      def test_unauthorized_overview
        get '/data/overview'
        assert_equal 401, last_response.status
      end

      def test_unauthorized_user_history
        get '/data/user_history'
        assert_equal 401, last_response.status
      end

      def test_unauthorized_visits_by_page
        get '/data/visits_by_page'
        assert_equal 401, last_response.status
      end

      def test_authorized_overview
        authorized_dashboard_request do
          get '/data/overview'
        end

        assert_equal 200, last_response.status
      end

      def test_authorized_user_history
        authorized_dashboard_request do
          get '/data/user_history'
        end

        assert_equal 200, last_response.status
      end

      def test_authorized_visits_by_page
        authorized_dashboard_request do
          get '/data/visits_by_page'
        end

        assert_equal 200, last_response.status
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
