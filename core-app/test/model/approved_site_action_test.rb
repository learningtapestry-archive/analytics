gem "minitest"
require 'minitest/autorun'
require 'database_cleaner'

class ApprovedSiteActionTest < Minitest::Test

  def self.before_suite
    DatabaseCleaner.strategy = :transaction
  end

  def setup
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end

  def test_get_actions_with_sites
    # TODO: Implement test
    skip
  end


end
