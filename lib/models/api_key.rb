require 'securerandom'
require 'lt/core'
require 'helpers/redis'

class ApiKey < ActiveRecord::Base
  extend Analytics::Helpers::Redis

  def self.create_api_key(user_id)
    if user_id.nil? then
      raise LT::ParameterMissing
    elsif !user_id.is_a? Integer
      raise LT::InvalidParameter, "User_id is invalid"
    elsif
      api_key = ApiKey.new
      api_key.user_id = user_id
      api_key.key = SecureRandom.uuid
      api_key.save

      keys_hash.set(api_key.key, LT.env.get_db_name)
      return api_key.key
    end
  end

  def self.get_by_api_key(api_key)
    if api_key.nil? || api_key.empty? then
      raise LT::ParameterMissing
    else
      api_key = ApiKey.where(key: api_key).first
      return api_key
    end
  end
end
