gem "minitest"
require 'minitest/autorun'
require 'database_cleaner'
require 'debugger'

class UserSecurityTest < Minitest::Test
  def test_password_hashing_validation
    password = 'xyzabc'
    username = 'foobar-user'
    first_name = 'first'
    last_name = 'last'
    user = User.create_user(:username=>username, :password=>password, :first_name => first_name,
      :last_name=>last_name)[:user]
    assert user.authenticate(password)
    user = User.where(:username => username).first
    assert user.authenticate(password)
  end

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
    user_data = {:username=>@username,:password=> @password, 
      :first_name => @first_name, :last_name =>@last_name}
    retval = User.create_user(user_data)
    user = retval[:user]
    assert_equal User, user.class
    assert_equal @username, user.username
    assert user.authenticate(@password)
    assert_equal @first_name, user.first_name
    assert_equal @last_name, user.last_name

    # test that duplicate usernames will fail without raising an exception
    retval = User.create_user(user_data)
    assert_equal ActiveRecord::RecordNotUnique, retval[:exception].class
    assert_match /exists/, retval[:error_msg]
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
    json_string = '{ "password": "testpassword" }'
    retval = User.create_user_from_json(json_string)
    assert_equal ActiveRecord::StatementInvalid, retval[:exception].class
    assert_match /required/, retval[:error_msg]
  end

  def test_create_user_from_valid_json
    retval = User.create_user_from_json(@user_json_string)
    user = retval[:user]
    assert_equal User, user.class
    assert_equal @username, user.username
    assert user.authenticate(@password)
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
    assert user.authenticate(@password)
    assert !retval[:exception]

    retval = User.get_validated_user(@username, "bs password no worky")
    user2 = retval[:user]
    assert !user2
    assert_equal LT::PasswordInvalid, retval[:exception].class

    retval = User.get_validated_user("bs username no worky", "pw doesn't matter")
    user2 = retval[:user]
    assert !user2
    assert_equal LT::UserNotFound, retval[:exception].class
  end

  def test_get_sites
    @scenario = LT::Scenarios::Students::create_joe_smith_scenario
    @joe_smith = @scenario[:student]
    @page_visits = @scenario[:page_visits]
    @sites = @scenario[:sites]
    @pages = @scenario[:pages]

    joe_smith = User.find_by_username([@joe_smith[:username]])
    refute_nil joe_smith

    sites_visited = joe_smith.get_site_visits(begin_date: 14.days.ago.strftime("%Y-%m-%d 00:00:00"), end_date: Time.now.strftime("%Y-%m-%d 23:59:59") )

    refute_nil sites_visited
    assert_equal 2, sites_visited.count
  end

  @first_run
  def before_suite
    if !@first_run
      DatabaseCleaner[:active_record].strategy = :transaction
      DatabaseCleaner[:redis].strategy = :truncation
    end
    @first_run = true
  end

  def teardown
    DatabaseCleaner.clean # cleanup of the database
  end
end