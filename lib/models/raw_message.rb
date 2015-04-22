require 'pry'

class RawMessage < ActiveRecord::Base
  has_many :raw_message_logs

  module Verbs
    VIEWED = 'viewed'
    CLICKED = 'clicked'
    VIDEO_ACTION = 'video-action'
  end

  def self.create_from_json(raw_json_msg)
    message = JSON.parse(raw_json_msg)
    # TODO - Optimize: this makes an org query per message
    # It should be possible to locally cache org_id's somehow to speed this up
    org_api_key = message["org_api_key"]
    if org_api_key then
      message["organization_id"] = Organization.find_by_org_api_key(org_api_key).id
    end
    retval = new_with_log(message, RawMessageLog.new_from_redis)
    retval.save
    retval
  end

  # create a new record with associated log_entry
  def self.new_with_log(message, log_entry)
    # TODO SECURITY verify that api_key and user_id in raw_message
    #   are associated with a record in api_key table
    #   We may want an option to skip validation of user_id/api_key
    #   Or make sure that org_api_key is valid
    record = new(message)
    record.raw_message_logs << log_entry
    record
  end

  def self.find_new_page_visits(limit = 100)
    self
      .select("#{table_name}.*")
      .joins(:raw_message_logs)
      .where(:verb => Verbs::VIEWED)
      .where(["#{RawMessageLog.table_name}.action = ?", RawMessageLog::Actions::FROM_REDIS])
      .where.not(id: RawMessageLog.select("raw_message_id").where(action: RawMessageLog::Actions::TO_PAGE_VISITS))
      .limit(limit)
  end

  def self.find_new_video_visits(limit = 100)
    ActiveRecord::Base.connection.execute("select msg.id, msg.org_api_key, organizations.id as org_id, user_id, username, page_title, url, action->>'session_id' as session_id, action->>'state' as state, action->>'video_id' as video_id, captured_at from raw_messages msg inner join organizations on (organizations.org_api_key = msg.org_api_key) where verb='video-action' order by session_id, captured_at limit #{limit};")
  end

  def self.ExtractIDFromYouTube(url)
    url
  end
end
