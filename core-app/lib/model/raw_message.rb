class RawMessage < ActiveRecord::Base
  has_many :raw_message_logs
  module Verbs
    VIEWED = 'viewed'
  end

  def self.create_from_json(raw_json_msg)
    message = JSON.parse(raw_json_msg)
    retval = new_with_log(message, RawMessageLog.new_from_redis)
    retval.save
    retval
  end

  # create a new record with associated log_entry
  def self.new_with_log(message, log_entry)
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
      .where(["#{RawMessageLog.table_name}.action <> ?", RawMessageLog::Actions::TO_PAGE_VISITS])
      .limit(limit)
  end

end
