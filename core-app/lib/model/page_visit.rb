require 'chronic'
require 'chronic_duration'

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

  # Create a page visit from a raw_message entry
  # raw_message: AR RawMessage instance
  # This method doesn't make sure that the raw_message hasn't already been processed as a page_visit
  # This method does validate the raw message verb
  def self.create_from_raw_message(raw_message)
    retval = {}
    if (raw_message[:verb] != RawMessage::Verbs::VIEWED) then
      retval[:exception] = ActiveRecord::StatementInvalid
      retval[:error_msg] = "RawMessage verb is not suitable. Was: #{raw_message[:verb]} Expected: #{RawMessage::Verbs::VIEWED}"
      return retval
    end
    pv_data = {}
    if raw_message["action"] && raw_message["action"]["time"] then
      time_active = raw_message["action"]["time"]
      pv_data[:time_active] = ChronicDuration.parse(time_active) if time_active.kind_of?(String)
    end
    pv_data[:date_visited] = raw_message["captured_at"]
    pv_data[:user_id] = raw_message["user_id"]
    # handle cases where user_id is missing but username is present
    # we will create a new user based on username if necessary
    if pv_data[:user_id].nil? then
      user = User.find_or_create_by(username: raw_message[:username], organization_id: raw_message[:organization_id])
      pv_data[:user_id] = user.id
    end
    pv_data[:page] = {
      display_name: raw_message["page_title"],
      url: raw_message["url"]
    }
    retval[:page_visit] = PageVisit.create_full(pv_data)[:page_visit]
    # tag RawMessage record as having been processed for page_visit
    raw_message.raw_message_logs << RawMessageLog.new_to_page_visits
    retval
  end

  # creates a new page_visit
  # will create underlying pages table entries as needed
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
    {page_visit: pv}
  end

end
