require 'securerandom'
require './lib/lt_base.rb'

class ApiKey < ActiveRecord::Base

  def self.GetApiKey(user_id)
    if user_id.nil? then
      raise LT::ParameterMissing
    elsif !user_id.is_a? Integer
      raise LT::InvalidParameter, "User_id is invalid"
    elsif
      api_key = ApiKey.new
      api_key.user_id = user_id
      api_key.key = SecureRandom.uuid
      api_key.save
      return api_key.key
    end
  end
end
