require 'test_helper'

class SiteModelTest < LT::Test::DBTestBase
  def setup
    super

    @codeacademy = Site.create!(display_name: 'Code Academy',
                                url: 'codeacademy.com')
  end

  def create_click
    @codeacademy.site_actions.create!(
      action_type: 'CLICK',
      url_pattern: 'http(s)?://(.*\\.)?codeacademy\\.(com|org)(/\\S*)?')
  end

  def test_get_all_with_actions_grabs_all_approved_sites
    create_click

    assert_equal 1, Site.get_all_with_actions.count
  end

  def test_get_all_with_actions_grabs_correct_urls
    create_click
    result = Site.get_all_with_actions

    assert_includes @codeacademy.url, result.first['url']
  end

  def test_get_all_with_actions_grabs_correct_site_actions
    create_click
    result = Site.get_all_with_actions
    action = result.first['site_actions'][0]['action_type']

    assert_includes @codeacademy.site_actions.first.action_type, action
  end
end
