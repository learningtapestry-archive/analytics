gem "minitest"
require 'minitest/autorun'
require 'database_cleaner'

class ApprovedSiteActionTest < Minitest::Test

  @first_run
  def before_suite
    if !@first_run
      DatabaseCleaner[:active_record].strategy = :transaction
      DatabaseCleaner[:redis].strategy = :truncation
    end
    @first_run = true
  end

  def setup
    before_suite
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
