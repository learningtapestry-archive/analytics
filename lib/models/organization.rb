require 'securerandom'
require 'lt/core'
require 'helpers/redis'

class Organization < ActiveRecord::Base
  include Analytics::Helpers::Redis

  has_many :users

  #
  # UUID v4 scheme. Notice the 3rd segment must begin with "4" and 4th 8,9,a,b
  #
  UUIDV4 = '[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}'

  after_save :update_redis_org_api_key

  before_validation :set_defaults, on: :create

  validates :org_api_key, format: { with: /#{UUIDV4}/i }

  def set_defaults
    if self.org_api_key.nil? then
      self.org_api_key = SecureRandom.uuid
    end
    if self.org_secret_key.nil? then
      self.org_secret_key = SecureRandom.hex(18)
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
    org_keys_hash.remove(self.org_api_key_was)

    # add org_api_key to redis
    org_keys_hash.set(self.org_api_key, self.id)

    return true
  end

  #
  # Will verify secret, after 4 invalid attempts, will lock account
  #
  def verify_secret(secret)
    return false if locked
    return true if org_secret_key == secret

    self.invalid_logins += 1
    self.locked = true if invalid_logins >= 4

    save!

    false
  end

  def self.find_or_create_user(org_api_key, username)
    organization = find_by(org_api_key: org_api_key)
    return unless organization

    organization.users.find_or_create_by(username: username)
  end
end
