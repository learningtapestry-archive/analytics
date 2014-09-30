gem "minitest"
require 'minitest/autorun'
require 'database_cleaner'

class ApiKeyModelTest < Minitest::Test

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

  def test_create_api_key_invalid_user_id
    # Missing parameter
    assert_raises LT::ParameterMissing do
      ApiKey.create_api_key(nil)
    end

    # Invalid JSON
    assert_raises LT::InvalidParameter do
      ApiKey.create_api_key("junk")
    end
  end

  def test_create_valid_api_key
    api_key = ApiKey.create_api_key(1)
    # Check we have a GUID formatted api key
    match = /^[A-Za-z0-9]{8}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{12}$/.match(api_key)    
    refute_nil match
 end

end
