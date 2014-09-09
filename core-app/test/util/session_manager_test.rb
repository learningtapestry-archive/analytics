gem "minitest"
require 'minitest/autorun'
require 'debugger'
require 'fileutils'
require 'tempfile'
require 'database_cleaner'
require './lib/lt_base.rb'
require './lib/util/session_manager.rb'
require './lib/model/user.rb'
require './lib/model/api_key.rb'

class SessionManagerTest < Minitest::Test

  def self.before_suite
    DatabaseCleaner.strategy = :transaction
  end

  def setup
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
    LT::RedisServer::boot_redis(File::expand_path('./db/redis.yml'))
  end
  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end

  def test_CreateUserFromJson_EmptyBadInvalidJson
    # Missing parameter
    assert_raises LT::ParameterMissing do
      LT::SessionManager.ValidateUser("", "")
    end
  end

  def test_ValidateUser_GetApiKey_ValidUser
    # Create new user as target for new API key
    user = User.CreateUser("testuser", "testpass", "First", "Last")

    # Ensure new user was created
    assert_equal user.username, "testuser"
    assert_equal user.password, Digest::MD5.hexdigest("testpass")

    # Use SessionManager to validate user and create new API key
    api_key = LT::SessionManager.ValidateUser("testuser", "testpass")

    # Ensure we received back API key
    match = /^[A-Za-z0-9]{8}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{12}$/.match(api_key)
    refute_nil match

    # Test in Redis that API key gives us a database name
    db_name = LT.get_db_name(File::expand_path('./db/config.yml'))
    db_name_redis = LT::RedisServer.api_key_get(api_key)
    assert_equal db_name, db_name_redis

    # Test that API key from Redis matches user in Postgres
    api_key_postgres = ApiKey.GetByApiKey(api_key)
    assert_equal api_key_postgres.user_id, user.id

    # Remove API key from Redis (API key will be removed from Postgres in transaction)
    LT::RedisServer.api_key_remove(api_key)
  end

  def test_ValidateUser_GetApiKey_InvalidUser

    # Invalid username test
    assert_raises LT::UserNotFound do
      api_key = LT::SessionManager.ValidateUser("invaliduser", "invalidpass")
    end

  end
end