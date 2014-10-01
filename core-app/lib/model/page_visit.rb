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

  # creates a new page_visit
  # will walk back to pages and sites to create all necessary underlying tables
  # data is a hash of attributes
  def self.create_full(data)
    page_data = data.delete(:page)
    pv = self.new(data)
    # if we aren't given a page_id, we need to find/create one
    if data[:page_id].nil? && !page_data.nil? then
      page = Page.find_or_create_by_url(page_data)
    end
    pv.page = page
    pv.save!
    pv
  end

end
