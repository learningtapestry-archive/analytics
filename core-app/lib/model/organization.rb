class Organization < ActiveRecord::Base
  has_many :users

  after_save :update_redis_org_api_key
  before_validation :set_defaults, on: :create
  # make sure that we have an org_api_key in proper format before saving
  # Please note, this is Version 4 of UUID scheme, notice the 3rd segment must begin with "4" and 4th 8,9,a,b
  validates :org_api_key, format: {with: /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}/i}

  def set_defaults
    if self.org_api_key.nil? then
      self.org_api_key = SecureRandom.uuid
    end
    if self.org_secret_key.nil? then
      self.org_secret_key = SecureRandom.hex(36)
    end
    return true
  end

  # resets all the org api keys in redis
  def self.update_all_org_api_keys
    Organization.all.each do |org|
      org.update_redis_org_api_key
    end
  end

  def update_redis_org_api_key
    # remove existing key from redis (we grab the old field value using "_was")
    LT::RedisServer::org_api_key_remove(self.org_api_key_was)
    # add org_api_key to redis
    LT::RedisServer::org_api_key_set(self.org_api_key, self.id)
    return true
  end

  # Will verify secret, after 4 invalid attempts, will lock account
  def verify_secret(secret)
    if self.org_secret_key == secret
      return true
    else
      self.invalid_logins += 1
      if self.invalid_logins >= 4 then self.locked = true end
      self.save
      return false
    end
  end

end # class Organization
