require 'chronic'
require 'chronic_duration'
class SiteVisit < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  belongs_to :user
  belongs_to :site
  has_one :student, through: :user
  has_one :staff_member, through: :user
  has_many :pages, through: :site

  delegate :url, :to => :site
  delegate :display_name, :to => :site

  def time_active
    retval = super
    # convert any string durations to their integer (seconds) equiv
    ChronicDuration.parse(retval) if retval.kind_of?(String)
  end
  def time_active_words
    distance_of_time_in_words(self.time_active) if self.time_active
  end
  #has_many :pages_visited, through: :pages
  # has_many :pages_visited, through: :pages, 
  #   select: 'distinct (pages_visited.id), pages_visited.*', 
  #   conditions: proc {["pages_visited.user_id = ?",self.user_id]}

end
