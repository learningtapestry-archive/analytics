test_helper_file = File::expand_path(File::join(LT::test_path,'test_helper.rb'))
require test_helper_file

class OrganizationTest < LTDBTestBase
  def test_create_simple
    # show that we can create an org with a predefined key
    # and that is the key that will be persisted
    org_api_key = SecureRandom.uuid
    o = Organization.create(org_api_key: org_api_key)
    assert !o.new_record?
    assert_equal org_api_key, o.org_api_key
  end

  def test_create_complex
    # show that redis has no org_api_keys
    assert_equal 0, LT::RedisServer::org_api_key_hashlist_length
    # create an org with no org_api_key
    # show that we automatically create an org_api_key
    o = Organization.create({})
    org_id = o.id
    org = Organization.find_by_id(org_id)
    org_api_key = org.org_api_key
    refute_nil org_api_key
    assert_match /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/i, org.org_api_key
    # show that redis gets this (and only this) org_api_key, and it matches our org_id
    assert_equal 1, LT::RedisServer::org_api_key_hashlist_length
    assert_equal org_id.to_s, LT::RedisServer::org_api_key_get(org_api_key)
    # show that when we change the org_api_key during update, redis reflects the change
    o.org_api_key = SecureRandom.uuid
    o.save
    assert_equal 1, LT::RedisServer::org_api_key_hashlist_length
    assert_equal o.id.to_s, LT::RedisServer::org_api_key_get(o.org_api_key)

    # show that creating an Organization with an invalid org_api_key format doesn't save
    # and gives us an error with a message related to the failure
    o = Organization.create({org_api_key: "foobar"})
    key, value = o.errors.messages.first
    assert_equal :org_api_key, key
    assert o.new_record?
    assert !o.id
    # show that the org_api_key queue didn't get longer
    # and doesn't have our new BS key in it
    assert_equal 1, LT::RedisServer::org_api_key_hashlist_length
    assert_equal nil, LT::RedisServer::org_api_key_get("foobar")
  end

  def setup
    super
  end
  def teardown
    super
  end
end
