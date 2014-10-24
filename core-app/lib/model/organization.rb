class Organization < ActiveRecord::Base
  has_many :users

  after_save :update_redis_org_api_key
  before_validation :set_defaults, on: :create
  # make sure that we have an org_api_key in proper format before saving
  validates :org_api_key, format: {with: /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/i}

  def set_defaults
    if self.org_api_key.nil? then
      self.org_api_key = SecureRandom.uuid
    end
    return true
  end

  def update_redis_org_api_key
    # remove existing key from redis (we grab the old field value using "_was")
    LT::RedisServer::org_api_key_remove(self.org_api_key_was)
    # add org_api_key to redis
    LT::RedisServer::org_api_key_set(self.org_api_key, self.id)
    return true
  end

end # class Organization
