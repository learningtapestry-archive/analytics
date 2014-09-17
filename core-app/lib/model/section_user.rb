class SectionUser < ActiveRecord::Base
  belongs_to :section
  belongs_to :user
  has_one :student, through: :user
  has_one :staff_member, through: :user


end
