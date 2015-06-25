require 'test_helper'

class VisitModelTest < LT::Test::DBTestBase
  def setup
    super

    Site.create!(display_name: 'Site', url: 'site.com')
    @page = Page.create!(display_name: 'Page', url: 'http://site.com/page')
  end

  def test_time_active_setter_parse_chronic_format_durations
    visit = Visit.create!(page: @page, time_active: '196S')

    assert_equal 196, visit.time_active
  end

  def test_by_dates_filters_visits_by_date
    visit = Visit.create!(page: @page, date_visited: 1.week.ago)

    assert_equal [visit], Visit.by_dates(1.week.ago.beginning_of_day, Time.now)
    assert_empty Visit.by_dates(6.days.ago, Time.now)
  end

  def test_summary_by_page_returns_visits_aggregated_by_page
    Visit.create!(page: @page)
    assert_equal 1, Visit.summary_by_page.length

    Visit.create!(page: @page)
    assert_equal 1, Visit.summary_by_page.length

    Visit.create!(page: Page.create!(url: 'http://site.com/page2'))
    assert_equal 2, Visit.summary_by_page.length
  end

  def test_summary_by_page_returns_custom_columns
    Visit.create!(page: @page)

    res = Visit.summary_by_page

    expected = {
      'site_domain' => @page.site.url, 'site_name' => @page.site.display_name,
      'page_url' => @page.url, 'page_name' => @page.display_name
    }

    assert_equal expected, res.first.attributes.slice(*expected.keys)
  end

  def test_summary_by_page_aggregates_total_time_by_page
    2.times { Visit.create!(page: @page, time_active: '2S') }

    res = Visit.summary_by_page

    assert_equal 4, res.first.attributes['total_time']
  end

  def test_summary_by_page_sorts_results_by_site_domain
    Visit.create!(page: Page.create!(url: 'http://zzz.com/page'))
    Visit.create!(page: @page)

    res = Visit.summary_by_page

    assert_equal 'site.com', res.first.attributes['site_domain']
    assert_equal 'zzz.com', res.last.attributes['site_domain']
  end

  def test_summary_by_site_returns_visits_aggregated_by_site
    Visit.create!(page: @page)
    assert_equal 1, Visit.summary_by_site.length

    Visit.create!(page: @page)
    assert_equal 1, Visit.summary_by_site.length

    Visit.create!(page: Page.create!(url: 'http://site.com/page2'))
    assert_equal 1, Visit.summary_by_site.length

    Visit.create!(page: Page.create!(url: 'http://another.com/page2'))
    assert_equal 2, Visit.summary_by_site.length
  end

  def test_summary_by_site_returns_custom_columns
    Visit.create!(page: @page)

    res = Visit.summary_by_site

    expected = {
      'site_domain' => @page.site.url, 'site_name' => @page.site.display_name,
    }

    assert_equal expected, res.first.attributes.slice(*expected.keys)
  end

  def test_summary_by_site_aggregates_total_time_by_site
    2.times { Visit.create!(page: @page, time_active: '2S') }

    res = Visit.summary_by_site

    assert_equal 4, res.first.attributes['total_time']
  end

  def test_summary_by_site_sorts_results_by_site_domain
    Visit.create!(page: Page.create!(url: 'http://zzz.com/page'))
    Visit.create!(page: @page)

    res = Visit.summary_by_site

    assert_equal 'site.com', res.first.attributes['site_domain']
    assert_equal 'zzz.com', res.last.attributes['site_domain']
  end
end
