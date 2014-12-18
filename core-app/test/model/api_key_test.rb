test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

class ApiKeyModelTest < LTDBTestBase

  def setup
    super
  end
  def teardown
    super
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

    # Check API key is in Redis
    redis_key = LT::RedisServer.api_key_get(api_key)
    refute_nil redis_key
 end

end
