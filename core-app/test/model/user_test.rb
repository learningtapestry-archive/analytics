test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

class UserSecurityTest < LTDBTestBase

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

  def setup
    super
  end
  def teardown
    super
  end
end

class UserModelTest < LTDBTestBase

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

  def test_sites_visits
    @scenario = LT::Scenarios::Students::create_joe_smith_scenario
    @joe_smith = @scenario[:student]
    @page_visits = @scenario[:page_visits]
    @sites = @scenario[:sites]
    @pages = @scenario[:pages]

    joe_smith = User.find_by_username([@joe_smith[:username]])
    refute_nil joe_smith
    begin_date = 14.days.ago
    end_date = Time.now
    sites_visited = joe_smith.site_visits_summary(begin_date: begin_date, end_date: end_date)
    refute_nil sites_visited
    # Nb: normally use "size" to get counts - length here works b/c AR associations are weird I think
    assert_equal 2, sites_visited.length 
  end

  def setup
    super

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

  def teardown
    super
  end
end