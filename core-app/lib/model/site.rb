class Site < ActiveRecord::Base
  has_many :site_visits
  has_many :pages
  # has_many :pages_visited, through: :pages, 
  #   select: 'distinct (pages_visited.id, sites_visited.user_id), pages_visited.*', 
  #   conditions: proc {["pages_visited.user_id = sites_visited.user_id"]}

end
