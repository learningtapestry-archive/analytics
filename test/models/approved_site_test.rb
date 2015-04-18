test_helper_file = File::expand_path(File::join(LT.environment.test_path,'test_helper.rb'))
require test_helper_file

require 'utils/scenarios'

class ApprovedSiteActionTest < LT::Test::DBTestBase
  def setup
    super
    @scenario = Analytics::Utils::Scenarios::Students::create_joe_smith_scenario
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
      if site["url"] == Analytics::Utils::Scenarios::Sites.khanacademy_data[:url] then
        khan_found = true
        khan_action_found = site["site_actions"][0]["action_type"] == Analytics::Utils::Scenarios::SiteActions.khanacademy_actions_data[:action_type]
      end
      if site["url"] == Analytics::Utils::Scenarios::Sites.codeacademy_data[:url] then
        codeacad_found = true
        codeacad_action_found = site["site_actions"][0]["action_type"] == Analytics::Utils::Scenarios::SiteActions.codeacademy_actions_data[:action_type]
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
      if site["url"] == Analytics::Utils::Scenarios::Sites.khanacademy_data[:url] then
        khan_found = true
        khan_action_found = site["site_actions"][0]["action_type"] == Analytics::Utils::Scenarios::SiteActions.khanacademy_actions_data[:action_type]
      end
      if site["url"] == Analytics::Utils::Scenarios::Sites.codeacademy_data[:url] then
        codeacad_found = true
        codeacad_action_found = site["site_actions"][0]["action_type"] == Analytics::Utils::Scenarios::SiteActions.codeacademy_actions_data[:action_type]
      end
    end

    assert_equal true, khan_found
    assert_equal true, codeacad_found

    assert_equal true, khan_action_found
    assert_equal true, codeacad_action_found
  end
end
