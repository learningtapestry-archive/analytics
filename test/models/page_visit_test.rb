require 'test_helper'

class PageVisitModelTest < LT::Test::DBTestBase
  def test_time_active_setter_parse_chronic_format_durations
    visit = PageVisit.create(time_active: '196S')

    assert_equal 196, visit.time_active
  end
end
