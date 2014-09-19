gem "minitest"
require 'minitest/autorun'
require 'database_cleaner'
require 'debugger'

class StudentModelTest < Minitest::Test
  def setup
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
    LT::Seeds::seed!
    @scenario = LT::Seeds::Students::create_joe_smith_scenario
    @joe_smith = @scenario[:student]
    @jane_doe = @scenario[:teacher]
    @section = @scenario[:section]
    @page_visits = @scenario[:page_visits]
    @site_visits = @scenario[:site_visits]
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
    assert_equal @site_visits.size, student.site_visits.size
    assert student.site_visits.size >= 2
    assert_equal @page_visits.size, student.page_visits.size
    assert student.page_visits.size >= 2
    section_found = 0
    student_found = 0
    khan_visit_count = 0
    first_page_visit_count = 0
    second_page_visit_count = 0
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
          student_found += 1
          student.each_site_visit do |site_visit|
            if site_visit.url == @sites.first[:url] then
              khan_visit_count += 1
            end
            student.each_page_visit do |page_visit|
              each_page_visited_list << page_visit
            end
          end
          student.page_visits.each do |page_visit|
            if page_visit.page.url == @pages.first[:url]
              first_page_visit_count += 1
            end
            if page_visit.page.url == @pages[1][:url]
              second_page_visit_count += 1
            end
          end
        end # if student.username 
      end
    end
    assert_equal 1, section_found
    assert_equal 1, student_found
    assert_equal 2, students_in_section_count
    assert_equal @site_visits.size, khan_visit_count
    assert_equal @page_visits.size, each_page_visited_list.uniq.size
    assert_equal 2, first_page_visit_count
    assert_equal 1, second_page_visit_count
  end

  def self.before_suite
    DatabaseCleaner.strategy = :transaction
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end
end

