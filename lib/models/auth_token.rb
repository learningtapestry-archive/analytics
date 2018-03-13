# frozen_string_literal: true

class AuthToken < ActiveRecord::Base
  belongs_to :dashboard

  before_create :generate_value

  def generate_value
    loop do
      self.value = SecureRandom.hex
      break unless AuthToken.exists?(value: value)
    end
  end
end
