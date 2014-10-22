require 'minitest/autorun'
require File::expand_path(File::join(LT::partner_lib_path,'learning_tapestry.rb'))

class LearningTapestryLibraryTest < Minitest::Test

  API_KEY = '5651668c-4e89-4d15-99b5-274c19d318b6'

  def setup
  end

  def teardown
  end

  def test_initialize
    ## Test initialization by passing in API key while creating new
    filters = { date_start: '10/21/2014', date_end: '10/23/2014', section: 'CompSci - 7E302 - Data Structures' }
    lt_client = LearningTapestry::Agent.new(api_key: API_KEY, entity: 'page_visits', filters: filters)
    refute_nil lt_client
    assert_equal API_KEY, lt_client.api_key
    assert_equal 'page_visits', lt_client.entity
    assert_equal filters, lt_client.filters

    ## Test initialization by passing in API key by manually setting attribute
    lt_client = LearningTapestry::Agent.new
    refute_nil lt_client
    assert_nil lt_client.api_key
    lt_client.api_key = API_KEY
    lt_client.entity = 'site_visits'
    lt_client.add_filter :date_start, '10/23/2014'
    lt_client.add_filter :date_end, '10/24/2014'
    lt_client.add_filter :section, 'CompSci - 6E209 - Parallel Processing'
    assert_equal API_KEY, lt_client.api_key
    assert_equal 'site_visits', lt_client.entity
    filters = { date_start: '10/23/2014', date_end: '10/24/2014', section: 'CompSci - 6E209 - Parallel Processing' }
    assert_equal filters, lt_client.filters
  end

  def test_obtain
    # TODO
  end
end