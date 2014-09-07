gem "minitest"
require 'minitest/autorun'
require 'debugger'
require 'fileutils'
require 'tempfile'
require 'database_cleaner'
require './lib/lt_base.rb'
require './lib/model/user.rb'

class UserModelTest < Minitest::Test

  @@user_json_string = <<-json
    {
      "username": "testuser",
      "password": "testpass",
      "first_name": "Test",
      "last_name": "User" 
    }
    json

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

  def test_CreateUser
    user = User.CreateUser("testuser1", "testpass1", "First1", "Last1")

    assert_equal "testuser1", user.username
    assert_equal Digest::MD5.hexdigest("testpass1"), user.password
    assert_equal "First1", user.first_name
    assert_equal "Last1", user.last_name
  end

  def test_CreateUserFromJson_EmptyUsername
    # Missing parameter
    assert_raises LT::ParameterMissing do
      User.CreateUser("", "", "", "")
    end
  end

  def test_CreateUserFromJson_EmptyBadInvalidJson
    # Missing parameter
    assert_raises LT::ParameterMissing do
      User.CreateUserFromJson(nil)
    end

    # Invalid JSON
    assert_raises LT::InvalidParameter do
      User.CreateUserFromJson("junk")
    end

    # Missing password
    assert_raises LT::InvalidParameter do
      json_string = '{ "username": "testuser" }'
      User.CreateUserFromJson(json_string)
    end

    # Missing username
    assert_raises LT::InvalidParameter do
      json_string = '{ "password": "testpassword" }'
      User.CreateUserFromJson(json_string)
    end
  end

  def test_CreateUserFromJson_ValidJson
    user = User.CreateUserFromJson(@@user_json_string)

    assert_equal "testuser", user.username
    assert_equal Digest::MD5.hexdigest("testpass"), user.password
    assert_equal "Test", user.first_name
    assert_equal "User", user.last_name
  end

  def test_ValidateUser
    user = User.CreateUserFromJson(@@user_json_string)

    user = User.ValidateUser("testuser", "testpass")
    assert_equal "testuser", user.username
    assert_equal Digest::MD5.hexdigest("testpass"), user.password
  end

end