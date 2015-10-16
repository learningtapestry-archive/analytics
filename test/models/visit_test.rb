require 'test_helper'

class VisitModelTest < LT::Test::DBTestBase
  def setup
    super

    Site.create!(display_name: 'Site', url: 'site.com')
    @page = Page.create!(display_name: 'Page', url: 'http://site.com/page')
    @joe_smith = User.create!(username: 'joesmith', password: 'pass', first_name: 'Joe', last_name: 'Smith')
  end

  def test_time_active_setter_parse_chronic_format_durations
    visit = Visit.create!(page: @page, user: @joe_smith, time_active: '196S')

    assert_equal 196, visit.time_active
  end

  def test_by_dates_filters_visits_by_date
    visits = [Visit.create!(page: @page, user: @joe_smith, date_visited: 1.week.ago, heartbeat_id: SecureRandom.hex(36)),
              Visit.create!(page: @page, user: @joe_smith, date_visited: 10.days.ago, heartbeat_id: SecureRandom.hex(36))]

    assert_equal visits.first, Visit.by_dates([1.week.ago.beginning_of_day], [Time.now]).first
    assert_equal visits, Visit.by_dates([15.days.ago.beginning_of_day, 1.week.ago.beginning_of_day],
                                        [9.days.ago.beginning_of_day, Time.now])
    assert_empty Visit.by_dates([6.days.ago], [Time.now])
  end

  def test_summary_by_page_returns_visits_aggregated_by_page
    Visit.create!(page: @page, user: @joe_smith, heartbeat_id: SecureRandom.hex(36))
    assert_equal 1, Visit.summary_by_page.length

    Visit.create!(page: @page, user: @joe_smith, heartbeat_id: SecureRandom.hex(36))
    assert_equal 1, Visit.summary_by_page.length

    Visit.create!(page: Page.create!(url: 'http://site.com/page2'), user: @joe_smith)
    assert_equal 2, Visit.summary_by_page.length
  end

  def test_summary_by_page_returns_custom_columns
    Visit.create!(page: @page, user: @joe_smith)

    res = Visit.summary_by_page

    expected = {
      'site_domain' => @page.site.url, 'site_name' => @page.site.display_name,
      'page_url' => @page.url, 'page_name' => @page.display_name,
      'username' => @joe_smith.username
    }

    assert_equal expected, res.first.attributes.slice(*expected.keys)
  end

  def test_summary_by_page_aggregates_total_time_by_page
    2.times { Visit.create!(page: @page, user: @joe_smith, time_active: '2S', heartbeat_id: SecureRandom.hex(36)) }

    res = Visit.summary_by_page

    assert_equal 4, res.first.attributes['total_time']
  end

  def test_summary_by_page_sorts_results_by_site_domain
    Visit.create!(page: Page.create!(url: 'http://zzz.com/page'), user: @joe_smith)
    Visit.create!(page: @page, user: @joe_smith)

    res = Visit.summary_by_page

    assert_equal 'site.com', res.first.attributes['site_domain']
    assert_equal 'zzz.com', res.last.attributes['site_domain']
  end

  def test_summary_by_site_returns_visits_aggregated_by_site
    Visit.create!(page: @page, user: @joe_smith, heartbeat_id: SecureRandom.hex(36))
    assert_equal 1, Visit.summary_by_site.length

    Visit.create!(page: @page, user: @joe_smith, heartbeat_id: SecureRandom.hex(36))
    assert_equal 1, Visit.summary_by_site.length

    Visit.create!(page: Page.create!(url: 'http://site.com/page2'), user: @joe_smith)
    assert_equal 1, Visit.summary_by_site.length

    Visit.create!(page: Page.create!(url: 'http://another.com/page2'), user: @joe_smith)
    assert_equal 2, Visit.summary_by_site.length
  end

  def test_summary_by_site_returns_custom_columns
    Visit.create!(page: @page, user: @joe_smith)

    res = Visit.summary_by_site

    expected = {
      'site_domain' => @page.site.url, 'site_name' => @page.site.display_name,
    }

    assert_equal expected, res.first.attributes.slice(*expected.keys)
  end

  def test_summary_by_site_aggregates_total_time_by_site
    2.times { Visit.create!(page: @page, user: @joe_smith, time_active: '2S', heartbeat_id: SecureRandom.hex(36)) }

    res = Visit.summary_by_site

    assert_equal 4, res.first.attributes['total_time']
  end

  def test_summary_by_site_sorts_results_by_site_domain
    Visit.create!(page: Page.create!(url: 'http://zzz.com/page'), user: @joe_smith)
    Visit.create!(page: @page, user: @joe_smith)

    res = Visit.summary_by_site

    assert_equal 'site.com', res.first.attributes['site_domain']
    assert_equal 'zzz.com', res.last.attributes['site_domain']
  end
end
