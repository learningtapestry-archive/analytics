require 'test_helper'

class UserModelTest < LT::Test::DBTestBase
  def setup
    super

    @user = User.create!(username: 'foobar-user',
                         password: 'xyabc',
                         first_name: 'first',
                         last_name: 'last')
  end

  def test_user_password_hashing_validation
    assert_equal @user, @user.authenticate('xyabc')
    assert_equal false, @user.authenticate('wrong')
  end

  def test_summary_sorts_by_username
    user2 = User.create!(username: 'zzz-user',
                         password: 'xyabc',
                         first_name: 'first',
                         last_name: 'last')

    assert_equal [@user, user2], User.summary
  end
end
