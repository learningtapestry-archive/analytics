# frozen_string_literal: true

class Dashboard < ActiveRecord::Base
  has_many :auth_tokens

  validates :name, presence: true, uniqueness: true

  after_create :create_auth_token

  private

  def create_auth_token
    auth_tokens.create!
  end
end
