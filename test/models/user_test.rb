require 'test_helper'

require 'utils/scenarios'

class UserModelTest < LT::Test::DBTestBase
  def test_user_password_hashing_validation
    user = User.create!(username: 'foobar-user',
                        password: 'xyabc',
                        first_name: 'first',
                        last_name: 'last')

    assert_equal user, user.authenticate('xyabc')
    assert_equal false, user.authenticate('wrong')
  end
end
