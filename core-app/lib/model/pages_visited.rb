class PagesVisited < ActiveRecord::Base
  belongs_to :user
  belongs_to :page
  has_one :student, through: :user
  has_one :staff_member, through: :user
  has_one :site, through: :page
  has_one :site_visited, through: :site
end
