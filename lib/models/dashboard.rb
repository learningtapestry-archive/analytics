# frozen_string_literal: true

class Dashboard < ActiveRecord::Base
  has_many :auth_tokens

  validates :name, presence: true, uniqueness: true

  after_create :create_auth_token

  def auth_token
    auth_tokens.order(:created_at).last
  end

  def self.find_by_token(token)
    token = AuthToken.find_by(value: token)
    dashboard = token&.dashboard

    return nil unless dashboard

    # check that this is the currently active token and not an expired one

    token if token == dashboard.auth_token
  end

  private

  def create_auth_token
    auth_tokens.create!
  end
end
