require 'test_helper'
require 'ffaker'
require 'byebug'

module Analytics
  module Test
    class ApiAppV2Test < WebAppTestBase
      #
      # Define what an ApprovedSite actually is... It seems like a join model
      # for 4 different models...
      #
      def test_approved_site_list
        school = School.create!(name: 'Acme School')

        ApprovedSite.create!([
                                 {school: school, site: Site.create!(url: 'aaa.com')},
                                 {school: school, site: Site.create!(url: 'zzz.com')}
                             ])

        request '/api/v2/approved-sites'
        response_json = JSON.parse(last_response.body, symbolize_names: true)

        assert_equal 200, last_response.status

        urls = response_json.map { |h| h[:url] }.sort
        assert_equal ['aaa.com', 'zzz.com'], urls
      end

      def test_service_status
        request '/api/v2/service-status'
        response_json = JSON.parse(last_response.body, symbolize_names: true)

        assert_equal 200, last_response.status
        assert_equal true, response_json[:database]
        assert_equal true, response_json[:redis]
      end

      def test_sites_returns_page_visit_information
        create_org_and_user

        page = Page.create!(url: 'http://page.com')
        @user.visits.create!(page: page, date_visited: 3.hours.ago.utc)

        params = {date_begin: '2014-01-01', date_end: Time.now.utc.to_s}.merge(default_params)

        resp = auth_request('api/v2/sites', params)

        assert_equal 1, resp[:results].size

        assert_equal %i(username site_visits), resp[:results].first.keys
        assert_equal %i(site_name site_domain total_time), resp[:results].first[:site_visits].first.keys
      end

      def test_pages_returns_page_visit_information
        create_org_and_user

        page = Page.create!(url: 'http://page.com')
        @user.visits.create!(page: page, date_visited: 3.hours.ago.utc)

        params = {date_begin: '2014-01-01', date_end: Time.now.utc.to_s}.merge(default_params)

        resp = auth_request('api/v2/pages', params)

        assert_equal 1, resp[:results].size

        first_result = resp[:results].first
        assert_equal %i(username page_visits), first_result.keys
        assert_equal %i(site_name site_domain page_name page_url total_time), first_result[:page_visits].first.keys
      end

      %w(sites pages users video-views).each do |path|
        define_method("test_#{path}_returns_unauthorized_when_no_api_key") do
          resp = auth_request("api/v2/#{path}", org_api_key: nil)

          assert_equal 401, last_response.status
          assert_equal 'Organization API key not provided', resp[:error]
        end

        define_method("test_#{path}_returns_unauthorized_when_invalid_key") do
          resp = auth_request("api/v2/#{path}", org_api_key: 'XXX')

          assert_equal 401, last_response.status
          assert_equal 'Unknown organization API key', resp[:error]
        end

        define_method("test_#{path}_returns_unauthorized_when_no_secret") do
          create_org_and_user

          resp = auth_request("api/v2/#{path}", org_api_key: @org.org_api_key)

          assert_equal 401, last_response.status
          assert_equal 'Organization secret key not provided', resp[:error]
        end
      end

      %w(sites pages).each do |path|
        define_method "test_#{path}_returns_meta_info" do
          create_org_and_user

          params = {date_begin: '2014-01-01', date_end: '2015-01-01'}.merge(default_params)

          resp = auth_request("/api/v2/#{path}", params)

          assert_equal 200, last_response.status

          assert_equal visits_type(path).to_s, resp[:entity]
          assert_includes resp[:date_range][:date_begin].first, '2014-01-01'
          assert_includes resp[:date_range][:date_end].first, '2015-01-01'
          assert_empty resp[:results]
        end

        define_method "test_#{path}_uses_default_values_for_date_ranges" do
          create_org_and_user

          resp = auth_request("/api/v2/#{path}", default_params)

          assert_equal 200, last_response.status

          date_range = resp[:date_range]
          assert_includes date_range[:date_begin].first, 1.day.ago.utc.to_date.to_s
          assert_includes date_range[:date_end].first, Time.now.utc.to_date.to_s
        end

        define_method "test_#{path}_filters_by_usernames" do
          create_org_and_user
          @user.visits.create!(page: Page.create!(url: 'http://page.com'),
                               date_visited: 3.hours.ago.utc)
          other_user = @org.users.create!(username: 'johndoe', password: 'pass', first_name: 'John', last_name: 'Doe')
          other_user.visits.create!(page: Page.create!(url: 'http://example.com'),
                                    date_visited: 3.hours.ago.utc,
                                    heartbeat_id: SecureRandom.hex(36))
          params = default_params.merge(usernames: 'johndoe, fake_user')

          resp = auth_request("/api/v2/#{path}", params)
          results = resp[:results].first[visits_type(path)]

          assert_equal 200, last_response.status
          assert_equal 1, results.size
          assert_equal 'example.com', results.first[:site_domain]
        end

        define_method "test_#{path}_filters_by_site_domains" do
          create_org_and_user
          create_example_visits

          params = default_params.merge(site_domains: 'example.org, example.net')
          resp = auth_request("/api/v2/#{path}", params)
          results = resp[:results].first[visits_type(path)].sort_by { |v| v[:site_domain] }

          assert_equal 200, last_response.status
          assert_equal 2, results.size
          assert_equal 'example.net', results.first[:site_domain]
          assert_equal 'example.org', results.last[:site_domain]
        end

        define_method "test_#{path}_returns_bad_request_when_no_usernames" do
          create_org_and_user

          resp = auth_request("/api/v2/#{path}",
                              org_api_key: @org.org_api_key,
                              org_secret_key: @org.org_secret_key)

          assert_equal 400, last_response.status
          assert_equal ':usernames array not provided', resp[:error]
        end

        define_method "test_#{path}_includes_date_visited_when_detail_is_requested" do
          create_org_and_user
          date_visited = 3.hours.ago.utc
          @user.visits.create!(page: Page.create!(url: 'http://example.com'),
                               date_visited: date_visited,
                               time_active: '25S')

          resp = auth_request("/api/v2/#{path}", default_params.merge(type: 'detail'))
          first_result = resp[:results].first[visits_type(path)].first

          assert_equal 200, last_response.status
          assert_includes first_result[:date_visited], date_visited.strftime('%Y-%m-%dT%H:%M:%S')
          assert_includes first_result[:date_left], (date_visited + 25.seconds).strftime('%Y-%m-%dT%H:%M:%S')
        end
      end

      def test_pages_filters_by_page_urls
        create_org_and_user
        create_example_visits

        params = default_params.merge(page_urls: 'http://example.org, http://example.net')
        resp = auth_request('/api/v2/pages', params)
        results = resp[:results].first[:page_visits].sort_by { |v| v[:page_url] }

        assert_equal 200, last_response.status
        assert_equal 2, results.size
        assert_equal 'http://example.net', results.first[:page_url]
        assert_equal 'http://example.org', results.last[:page_url]
      end

      def test_users_reports_information_about_organization_users
        create_org_and_user

        resp = auth_request('/api/v2/users', default_params)

        assert_equal 200, last_response.status

        expected = {
            first_name: 'Joe', last_name: 'Smith', username: 'joesmith'}

        assert_equal [expected], resp[:results]
      end

      def test_video_views_returns_available_visualizations
        create_org_and_user

        vid = Video.create!(url: 'http://youtube.com?v=1')
        @user.visualizations.create!(video: vid,
                                     session_id: 'A' * 36,
                                     date_started: 1.hour.ago.utc,
                                     date_ended: 30.minutes.ago.utc)

        resp = auth_request('/api/v2/video-views', default_params)

        assert_equal 200, last_response.status
        assert_equal 1, resp[:results].size
      end

      def test_video_views_filters_by_usernames
        create_org_and_user
        @user.visualizations.create!(video: Video.create!(url: 'http://youtube.com?v=1'),
                                     session_id: 'A' * 36,
                                     date_started: 1.hour.ago.utc,
                                     date_ended: 30.minutes.ago.utc)
        other_user = @org.users.create!(username: 'johndoe', password: 'pass', first_name: 'John', last_name: 'Doe')
        other_user.visualizations.create!(video: Video.create!(url: 'http://youtube.com?v=2'),
                                          session_id: 'B' * 36,
                                          date_started: 1.hour.ago.utc,
                                          date_ended: 30.minutes.ago.utc)
        params = default_params.merge(usernames: 'johndoe, fake_user')

        resp = auth_request('/api/v2/video-views', params)

        assert_equal 200, last_response.status
        assert_equal 1, resp[:results].size
        assert_equal 'http://youtube.com?v=2', resp[:results].first[:url]
      end

      def test_pages_heavy_load
        create_org_and_user
        create_visits_for_load_test

        params = default_params.merge(
          type: 'detail',
          usernames: @org.users.pluck(:username).join(',')
        )
        started_at = Time.now
        auth_request("/api/v2/pages", params)
        finished_at = Time.now
        time_taken = finished_at - started_at

        assert time_taken < 7, "too slow #{time_taken}s > 7s"
      end

      private

      def create_org_and_user
        @org = Organization.create!(
            name: 'Acme Organization',
            org_api_key: '00000000-0000-4000-8000-000000000000')

        @user = @org.users.create!(
            username: 'joesmith',
            password: 'pass',
            first_name: 'Joe',
            last_name: 'Smith')
      end

      def create_example_visits
        @user.visits.create!(page: Page.create!(url: 'http://example.com'), date_visited: 3.hours.ago.utc)
        @user.visits.create!(page: Page.create!(url: 'http://example.org'), date_visited: 3.hours.ago.utc)
        @user.visits.create!(page: Page.create!(url: 'http://example.net'), date_visited: 3.hours.ago.utc)
      end

      def create_visits_for_load_test
        connection = ActiveRecord::Base.connection
        time_active = 10
        date_visited = 3.hours.ago.utc
        site_id = Site.create!(url: 'http://example.com').id
        5.times do
          user_id = connection.insert_sql("INSERT INTO users (username, organization_id) VALUES('#{FFaker::Internet.user_name}', #{@org.id})")
          10000.times do
            url = "http://example.com/#{FFaker::Lorem.word}#{rand}.html"
            page_id = connection.insert_sql("INSERT INTO pages (site_id, url) VALUES(#{site_id}, '#{url}')")
            connection.insert_sql("INSERT INTO visits (user_id, page_id, time_active, date_visited, heartbeat_id) VALUES(#{user_id}, #{page_id}, #{time_active}, '#{date_visited}', '#{SecureRandom.hex(36)}')")
          end
        end
      end

      def default_params
        {
            org_api_key: @org.org_api_key,
            org_secret_key: @org.org_secret_key,
            usernames: @user.username
        }
      end

      def auth_request(url, params = {})
        headers = {'content_type' => 'application/json'}

        get url, params, headers

        JSON.parse(last_response.body, symbolize_names: true)
      end

      def visits_type(type)
        type == 'sites' ? :site_visits : :page_visits
      end
    end
  end
end
