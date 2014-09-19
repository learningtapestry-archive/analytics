class Page < ActiveRecord::Base
  has_many :page_visits
  belongs_to :site
end
