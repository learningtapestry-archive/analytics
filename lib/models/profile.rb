class Profile < ActiveRecord::Base
  belongs_to :user

  has_many :emails, through: :user
  has_one :organization, through: :user
  has_one :school, through: :user

  delegate :full_name, :first_name, :last_name, :username, :email, :sections,
           to: :user
end
