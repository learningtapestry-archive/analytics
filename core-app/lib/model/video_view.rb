class VideoView < ActiveRecord::Base
  belongs_to :user
  belongs_to :page
  has_one :student, through: :user
  has_one :staff_member, through: :user
  has_one :site, through: :page
  has_one :site_visited, through: :site

  delegate :url, :to => :page



  # Create a page visit from a raw_message entry
  # raw_message: AR RawMessage instance
  # This method doesn't make sure that the raw_message hasn't already been processed as a page_visit
  # This method does validate the raw message verb
  def self.create_from_raw_message(raw_message)
    retval = {}
    if (raw_message[:verb] != RawMessage::Verbs::VIDEO_ACTION) then
      retval[:exception] = ActiveRecord::StatementInvalid
      retval[:error_msg] = "RawMessage verb is not suitable. Was: #{raw_message[:verb]} Expected: #{RawMessage::Verbs::VIDEO_ACTION}"
      return retval
    end


    if raw_message['action']
      vv_data = {}
      time_viewed = raw_message['action']['captured_at']
      vv_data[:video_id] = raw_message['action']['video_id']
      vv_data[:user_id] = raw_message['action']['username']
      #vv_data[:page_url] = raw_message['action']['url']
      #vv_data[:captured_at] = ChronicDuration.parse(time_viewed) if time_viewed.kind_of?(String)

      retval = VideoView.create_full(vv_data)
    end

    retval
  end

  # creates a new page_visit
  # will create underlying pages table entries as needed
  # data is a hash of attributes
  def self.create_full(data)
    video_view = self.new(data)
    # if we aren't given a page_id, we need to find/create one
    if data[:page_id].nil? && !data[:page_url].nil? then
      page = Page.find_or_create_by_url(data[:page_url])
      data[:page_url].remove
    end

    video_view.page = page
    video_view.save!
    {video_view: video_view}
  end

end
