class PageClick < ActiveRecord::Base
  belongs_to :user
  has_one :profile, through: :user

  belongs_to :page
  has_one :site, through: :page
  has_one :site_visited, through: :site

  delegate :url, to: :page
end
