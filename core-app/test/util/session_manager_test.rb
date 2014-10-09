test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

class SessionManagerTest < LTDBTestBase

  def setup
    super
  end
  def teardown
    super
  end

  def test_create_user_from_invalid_json
    # Missing parameter
    assert_raises LT::ParameterMissing do
      LT::SessionManager.validate_user("", "")
    end
  end

  def test_validate_user_and_api_key
    # Create new user as target for new API key
    password = 'xyzabc'
    username = 'foobar-user'
    first_name = 'first'
    last_name = 'last'
    user = User.create_user(:username=>username, :password=>password, :first_name => first_name,
      :last_name=>last_name)[:user]

    # Ensure new user was created
    assert_equal username, user.username
    assert user.authenticate(password)

    # Use SessionManager to validate user and create new API key
    api_key = LT::SessionManager.validate_user(username, password)

    # Ensure we received back API key
    match = /^[A-Za-z0-9]{8}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{12}$/.match(api_key)
    refute_nil match

    # Test in Redis that API key gives us a database name
    db_name_redis = LT::RedisServer.api_key_get(api_key)
    assert_equal LT.get_db_name, db_name_redis

    # Test that API key from Redis matches user in Postgres
    api_key_postgres = ApiKey.get_by_api_key(api_key)
    assert_equal api_key_postgres.user_id, user.id

    # Remove API key from Redis (API key will be removed from Postgres in transaction)
    LT::RedisServer.api_key_remove(api_key)
  end

  def test_validate_invalid_user

    # Invalid username test
    assert_raises LT::UserNotFound do
      api_key = LT::SessionManager.validate_user("invaliduser", "invalidpass")
    end

  end
end