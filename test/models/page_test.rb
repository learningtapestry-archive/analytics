require 'test_helper'
require 'utils/scenarios'

class PageModelTest < LT::Test::DBTestBase
  include Analytics::Utils::Scenarios::Pages

  def test_url_attr_writer_sets_url_field
    assert_equal wordpress_url, wordpress_page.url
  end

  def test_url_attr_writer_sets_associated_site
    assert_equal 'wordpress.com', wordpress_page.site.url
  end

  private

  def wordpress_url
    'http://wordpress.com/whats-in-my-hospital-bag/'
  end

  def wordpress_page
    Page.create!(url: wordpress_url)
  end
end
