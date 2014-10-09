test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

class StudentModelTest < LTDBTestBase
  def setup
    super
    LT::Seeds::seed!
    @scenario = LT::Scenarios::Students::create_joe_smith_scenario
    @joe_smith = @scenario[:student]
    @jane_doe = @scenario[:teacher]
    @section = @scenario[:section]
    @page_visits = @scenario[:page_visits]
    @sites = @scenario[:sites]
    @pages = @scenario[:pages]
  end

  def test_relationships
    # basic data relationships
    student = Student.find_by_username(@joe_smith[:username])
    teacher = StaffMember.find_by_username(@jane_doe[:username])
    assert_equal @joe_smith[:username], student.username
    assert student.user
    assert_equal @joe_smith[:email], student.email
    assert_equal @jane_doe[:username], teacher.username
    # teachers belong to sections
    section = teacher.sections.find_by_section_code(@section[:section_code])
    assert_equal @section[:section_code], section.section_code
    assert_equal 'Teacher', section.teachers.first.user_type
    # students belong to sections
    section = student.sections.find_by_section_code(@section[:section_code])
    assert_equal @section[:section_code], section.section_code
    su = section.students
    joe_smith_section_student = su.detect do |student|
      student.username == @joe_smith[:username]
    end
    assert_equal @joe_smith[:username], joe_smith_section_student.username
  end

  def test_page_site_visits
    # Joe Smith has visited some Khan Academy sites recently
    student = Student.find_by_username(@joe_smith[:username])
    teacher = StaffMember.find_by_username(@jane_doe[:username])
    assert_equal @page_visits.size, student.page_visits.size
    assert student.page_visits.size >= 2
    section_found = 0
    joe_smith_found = 0
    #khan_site_visit_count = 0
    students_in_section_count = 0
    each_page_visited_list = []
    # test data browsing that we expect to need for dashboard view
    teacher.sections.each do |section|
      if section.section_code == @section[:section_code] then
        section_found += 1
      end
      section.students.each do |student|
        students_in_section_count += 1
        if student.username == @joe_smith[:username] then
          joe_smith_found += 1
          student.site_visits_summary(begin_date: 14.days.ago).each do |site|
            student.page_visits_summary(site: site, begin_date: 14.days.ago).each do |page_visit|
              if site.url == @sites.first[:url] then
                each_page_visited_list << page_visit
              end # if site.url
            end # student.each_page_visit
          end # student.site_visits
        end # if student.username 
      end #section.students.each
    end # teacher.sections.each
    khan_page_visits_actual = @page_visits.count do |visit|
      visit[:url].match(/khanacademy/) && (visit[:date_visited] > Time.now - User::DEFAULT_VISIT_TIME_FRAME)
    end
    #TODO:  This test can be improved with checking site visit durations
    assert_equal 3, khan_page_visits_actual
    assert_equal 1, section_found
    assert_equal 1, joe_smith_found
    assert_equal 2, students_in_section_count
    assert_equal 2, each_page_visited_list.uniq.size
    # loop through every page visited and make sure it's
    # in the list of @page_visits we expected
    each_page_visited_list.delete_if do |page_visit|
      @page_visits.find {|pv| 
        pv[:url] == page_visit.url
      }
    end
  
    assert_equal 0, each_page_visited_list.size
  end

  def teardown
    super
  end
end

