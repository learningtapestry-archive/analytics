class SiteVisit < ActiveRecord::Base
  belongs_to :user
  belongs_to :site
  has_one :student, through: :user
  has_one :staff_member, through: :user
  has_many :pages, through: :site

  delegate :url, :to => :site

  #has_many :pages_visited, through: :pages
  # has_many :pages_visited, through: :pages, 
  #   select: 'distinct (pages_visited.id), pages_visited.*', 
  #   conditions: proc {["pages_visited.user_id = ?",self.user_id]}

end
