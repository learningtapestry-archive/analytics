test_helper_file = File::expand_path(File::join(LT.environment.test_path,'test_helper.rb'))
require test_helper_file

require 'helpers/redis'

class OrganizationTest < LT::Test::DBTestBase
  include Analytics::Helpers::Redis

  def test_create_simple
    # show that we can create an org with a predefined key
    # and that is the key that will be persisted
    org_api_key = SecureRandom.uuid
    org_secret_key = SecureRandom.hex(36)
    o = Organization.create(org_api_key: org_api_key, org_secret_key: org_secret_key)
    assert !o.new_record?
    assert_equal org_api_key, o.org_api_key
  end

  def test_create_complex
    # show that redis has no org_api_keys
    assert_equal 0, org_keys_hash.length
    # create an org with no org_api_key
    # show that we automatically create an org_api_key
    o = Organization.create({})
    org_id = o.id
    org = Organization.find_by_id(org_id)
    org_api_key = org.org_api_key
    refute_nil org_api_key
    assert_match /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/i, org.org_api_key
    # show that redis gets this (and only this) org_api_key, and it matches our org_id
    assert_equal 1, org_keys_hash.length
    assert_equal org_id.to_s, org_keys_hash.get(org_api_key)

    # show that when we change the org_api_key during update, redis reflects the change
    o.org_api_key = SecureRandom.uuid
    o.org_secret_key = SecureRandom.hex(36)
    o.save
    assert_equal 1, org_keys_hash.length
    assert_equal o.id.to_s, org_keys_hash.get(o.org_api_key)

    # show that creating an Organization with an invalid org_api_key format doesn't save
    # and gives us an error with a message related to the failure
    o = Organization.create({org_api_key: "foobar"})
    key, value = o.errors.messages.first
    assert_equal :org_api_key, key
    assert o.new_record?
    assert !o.id
    # show that the org_api_key queue didn't get longer
    # and doesn't have our new BS key in it
    assert_equal 1, org_keys_hash.length
    assert_equal nil, org_keys_hash.get("foobar")
  end

  def test_locked_account
    org = Organization.new
    org.org_api_key = SecureRandom.uuid
    org.org_secret_key = SecureRandom.hex(36)
    org.save
    assert_equal 0, org.invalid_logins
    refute org.locked
    success = org.verify_secret SecureRandom.hex(36)
    refute success
    assert_equal 1, org.invalid_logins
    refute org.locked

    ## Send the wrong secret to the account 3 times to lock out account
    3.times do
      success = org.verify_secret SecureRandom.hex(36)
      refute success
    end

    assert org.locked
  end
end
