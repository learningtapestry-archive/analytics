class Page < ActiveRecord::Base
  has_many :pages_visited
  belongs_to :site
end
