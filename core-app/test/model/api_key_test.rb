gem "minitest"
require 'minitest/autorun'
require 'debugger'
require 'fileutils'
require 'tempfile'
require 'database_cleaner'
require './lib/lt_base.rb'
require './lib/model/api_key.rb'

class ApiKeyModelTest < Minitest::Test

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

  def test_CreateApiKey_EmptyBadInvalidUserId
    # Missing parameter
    assert_raises LT::ParameterMissing do
      ApiKey.CreateApiKey(nil)
    end

    # Invalid JSON
    assert_raises LT::InvalidParameter do
      ApiKey.CreateApiKey("junk")
    end
  end

  def test_CreateApiKey_ValidApiKey
    api_key = ApiKey.CreateApiKey(1)
    # Check we have a GUID formatted api key
    match = /^[A-Za-z0-9]{8}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{12}$/.match(api_key)    
    refute_nil match
 end

end
