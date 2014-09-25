class PageVisit < ActiveRecord::Base
  include ActionView::Helpers::DateHelper
  belongs_to :user
  belongs_to :page
  has_one :student, through: :user
  has_one :staff_member, through: :user
  has_one :site, through: :page
  has_one :site_visited, through: :site

  delegate :url, :to => :page
  delegate :display_name, :to => :page

  def time_active
    retval = super
    # convert any string durations to their integer (seconds) equiv
    ChronicDuration.parse(retval) if retval.kind_of?(String)
  end
  def time_active_words
    distance_of_time_in_words(self.time_active) if self.time_active
  end
end
