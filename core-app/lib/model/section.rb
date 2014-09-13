class Section < ActiveRecord::Base
  has_many :sections_users
  has_many :users, through: :sections_users
end
