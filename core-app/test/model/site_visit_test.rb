gem "minitest"
require 'minitest/autorun'
require 'database_cleaner'
require 'debugger'

class SiteVisitModelTest < Minitest::Test
  def setup
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
    LT::Seeds::seed!
    @scenario = LT::Scenarios::Students::create_joe_smith_scenario
    @joe_smith = @scenario[:student]
    @jane_doe = @scenario[:teacher]
    @section = @scenario[:section]
    @page_visits = @scenario[:page_visits]
    @site_visits = @scenario[:site_visits]
    @sites = @scenario[:sites]
    @pages = @scenario[:pages]
  end

  def test_relationships
    # returns 1 site_visit structure per site, aggregating across time_range
    student = User.find_by_username(@joe_smith[:username])
    time_range = 1.week
    site_visits_expected = [{
       :url => 'http://www.khanacademy.org',
       :time_active => 42.minutes+33.minutes
      },
      {:url =>'http://www.codeacademy.com',
       :time_active => 33.minutes
      }]
    page_visits_expected = [{
       :url => 'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-decimals-to-fractions-2-ex-1',
       :time_active => 15.minutes+12.minutes
      },
      {
       :url => 'https://www.khanacademy.org/math/cc-eighth-grade-math/cc-8th-numbers-operations/cc-8th-irrational-numbers/v/converting-a-fraction-to-a-repeating-decimal',
       :time_active => 7.minutes
      },
      {
       :url => 'http://www.codecademy.com/courses/ruby-beginner-en-F3loB/0/2?curriculum_id=5059f8619189a5000201fbcb',
       :time_active => 8.minutes
      }]
    khan_found = 0
    codea_found = 0
    pages_found = 0
    student.each_site_visit(:time_range => 1.week) do |site_visit|
      if site_visit.url == site_visits_expected.first[:url] then
        khan_found += 1
        assert_equal site_visits_expected.first[:time_active], site_visit.time_active
      end
      if site_visit.url == site_visits_expected.last[:url] then
        codea_found += 1
        assert_equal site_visits_expected.last[:time_active], site_visit.time_active
      end
      student.each_page_visit(site: site_visit) do |page_visit|
        page_visits_expected.delete_if do |pv|
          pv[:url] == page_visit.url && pv[:time_active] == page_visit.time_active
        end
        pages_found += 1
      end
    end
    assert_equal 1, khan_found
    assert_equal 1, codea_found
    assert_equal 3, pages_found
    # we should have deleted all the page visits from this structure (meaning we found them all)
    assert_equal 0, page_visits_expected.size
  end

  def self.before_suite
    DatabaseCleaner.strategy = :transaction
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end
end

