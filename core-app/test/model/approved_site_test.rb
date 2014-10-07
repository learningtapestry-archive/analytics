gem "minitest"
require 'minitest/autorun'
require 'database_cleaner'

class ApprovedSiteActionTest < Minitest::Test
  def setup
    before_suite
    DatabaseCleaner.start
    @scenario = LT::Scenarios::Students::create_joe_smith_scenario
    @school = @scenario[:school]
    @sites = @scenario[:sites]
    @site_actions = @scenario[:site_actions]
    @approved_sites = @scenario[:approved_sites]
  end

  def test_get_with_actions_by_school
    school = School.find_by_name(@school[:name])
    assert_equal school.name, @school[:name]
    as = ApprovedSite.get_with_actions_by_school(school)
    assert_equal as.count, 2

    khan_found = false; khan_action_found = false
    codeacad_found = false; codeacad_action_found = false
    as.each do |site|
      if site["url"] == LT::Scenarios::Sites.khanacademy_data[:url] then 
        khan_found = true
        khan_action_found = site["site_actions"][0]["action_type"] == LT::Scenarios::SiteActions.khanacademy_actions_data[:action_type]
      end
      if site["url"] == LT::Scenarios::Sites.codeacademy_data[:url] then 
        codeacad_found = true
        codeacad_action_found = site["site_actions"][0]["action_type"] == LT::Scenarios::SiteActions.codeacademy_actions_data[:action_type]
      end
    end

    assert_equal true, khan_found
    assert_equal true, codeacad_found

    assert_equal true, khan_action_found
    assert_equal true, codeacad_action_found
  end

  def test_get_all_with_actions
    as = ApprovedSite.get_all_with_actions
    assert_equal as.count, 2

    khan_found = false; khan_action_found = false
    codeacad_found = false; codeacad_action_found = false
    as.each do |site|
      if site["url"] == LT::Scenarios::Sites.khanacademy_data[:url] then 
        khan_found = true
        khan_action_found = site["site_actions"][0]["action_type"] == LT::Scenarios::SiteActions.khanacademy_actions_data[:action_type]
      end
      if site["url"] == LT::Scenarios::Sites.codeacademy_data[:url] then 
        codeacad_found = true
        codeacad_action_found = site["site_actions"][0]["action_type"] == LT::Scenarios::SiteActions.codeacademy_actions_data[:action_type]
      end
    end

    assert_equal true, khan_found
    assert_equal true, codeacad_found

    assert_equal true, khan_action_found
    assert_equal true, codeacad_action_found
  end

  @first_run
  def before_suite
    if !@first_run
      DatabaseCleaner[:active_record].strategy = :transaction
      DatabaseCleaner[:redis].strategy = :truncation
      DatabaseCleaner[:redis, {connection: LT::RedisServer.connection_string}]
    end
    @first_run = true
  end

  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end
end
