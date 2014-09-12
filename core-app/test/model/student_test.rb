gem "minitest"
require 'minitest/autorun'
require 'database_cleaner'
require 'debugger'

class StudentModelTest < Minitest::Test
  def setup
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
    LT::Seeds::seed!
    @joe_smith = LT::Seeds::Students::create_joe_smith
  end

  def test_relationships
    student = Student.find_by_username(@joe_smith[:username])
    assert_equal @joe_smith[:username], student.username
    assert student.user
    assert_equal @joe_smith[:email], student.email

  end

  def self.before_suite
    DatabaseCleaner.strategy = :transaction
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end
end

