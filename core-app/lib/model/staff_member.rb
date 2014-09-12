class StaffMember < ActiveRecord::Base
  belongs_to :user
  has_many :emails, through: :user

end
