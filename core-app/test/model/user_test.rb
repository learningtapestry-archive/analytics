gem "minitest"
require 'minitest/autorun'
require 'database_cleaner'

class UserSecurityTest < Minitest::Test
  def test_password_hashing_validation
    password = 'xyzabc'
    username = 'foobar-user'
    first_name = 'first'
    last_name = 'last'
    user = User.create_user(:username=>username, :password=>password, :first_name => first_name,
      :last_name=>last_name)[:user]
    assert user.password_matches?(password)
    user = User.where(:username => username).first
    assert user.password_matches?(password)
  end

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
end

class UserModelTest < Minitest::Test
  def setup
    # set database transaction, so we can revert seeds
    DatabaseCleaner.start
    @username = "testuser"
    @password = "testpass"
    @first_name = "Test"
    @last_name = "User"
    @user_json_string = <<-json
    {
      "username": "#{@username}",
      "password": "#{@password}",
      "first_name": "#{@first_name}",
      "last_name": "#{@last_name}" 
    }
    json
  end

  def test_create_user
    retval = User.create_user({:username=>@username,
     :password=> @password, :first_name => @first_name, :last_name =>@last_name})
    user = retval[:user]
    assert_equal User, user.class
    assert_equal @username, user.username
    assert user.password_matches?(@password)
    assert_equal @first_name, user.first_name
    assert_equal @last_name, user.last_name
  end

  def test_create_user_from_invalid_json
    # Missing parameter
    assert_raises TypeError do
      User.create_user_from_json({})
    end

    # Missing password
    assert_raises KeyError do
      json_string = '{ "username": "testuser" }'
      User.create_user_from_json(json_string)
    end

    # Missing username
    assert_raises ActiveRecord::StatementInvalid do
      json_string = '{ "password": "testpassword" }'
      User.create_user_from_json(json_string)
    end
  end

  def test_create_user_from_valid_json
    retval = User.create_user_from_json(@user_json_string)
    user = retval[:user]
    assert_equal User, user.class
    assert_equal @username, user.username
    assert user.password_matches?(@password)
    assert_equal @first_name, user.first_name
    assert_equal @last_name, user.last_name
  end

  def test_validate_user_from_json
    retval = User.create_user_from_json(@user_json_string)
    user = retval[:user]
    assert !retval[:exception]

    retval = User.get_validated_user(@username, @password)
    user1 = retval[:user]
    assert_equal User, user.class
    assert_equal @username, user.username
    assert user.password_matches?(@password)
    assert !retval[:exception]

    retval = User.get_validated_user(@username, "bs password no worky")
    user2 = retval[:user]
    assert !user2
    assert_equal LT::PasswordInvalid, retval[:exception]
  end

  def self.before_suite
    DatabaseCleaner.strategy = :transaction
  end

  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end
end