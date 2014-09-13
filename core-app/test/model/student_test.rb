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
  end

  def test_relationships
    student = Student.find_by_username(@joe_smith[:username])
    teacher = StaffMember.find_by_username(@jane_doe[:username])
    assert_equal @joe_smith[:username], student.username
    assert student.user
    assert_equal @joe_smith[:email], student.email
    assert_equal @jane_doe[:username], teacher.username
    section = teacher.sections.find_by_section_code(@section[:section_code])
    assert_equal @section[:section_code], section.section_code
  end

  def self.before_suite
    DatabaseCleaner.strategy = :transaction
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end
end

