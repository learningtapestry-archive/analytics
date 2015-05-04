require 'test_helper'
require 'utils/scenarios'

class PageModelTest < LT::Test::DBTestBase
  include Analytics::Utils::Scenarios::Sites
  include Analytics::Utils::Scenarios::Pages
  include Analytics::Utils::Scenarios::Students

  def test_url_attr_writer_sets_url_field
    assert_equal wordpress_url, wordpress_page.url
  end

  def test_url_attr_writer_sets_associated_site
    assert_equal 'wordpress.com', wordpress_page.site.url
  end

 def test_summary
    site = Site.create!(khanacademy)
    Site.create!(codeacademy)

    Page.create!([khanacademy_page1, khanacademy_page2, codeacademy_page])

    user = User.create!(joe_smith_data)
    Visit.find_each { |visit| visit.update!(user: user) }

    assert_equal 2, Page.summary(user, site: site).size
  end

  private

  def wordpress_url
    'http://wordpress.com/whats-in-my-hospital-bag/'
  end

  def wordpress_page
    Page.create!(url: wordpress_url)
  end
end