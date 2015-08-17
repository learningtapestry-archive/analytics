#
# An event captured by the JS plugin into a Redis queue
#
class RawMessage < ActiveRecord::Base
  enum verb: %i(viewed clicked video_action)

  #
  # Custom setter for captured_at attribute. Parses a string into a properly
  # formatted DateTime object.
  #
  def captured_at=(value)
    self[:captured_at] = DateTime.parse(value)
  end

  #
  # Video visits yet to be processed into VideoVisit objects
  #
  def self.video_msgs(limit)
    video_action.unprocessed(limit)
  end

  #
  # Page visits yet to be processed into Visit objects
  #
  def self.page_msgs(limit)
    viewed.unprocessed(limit)
  end

  #
  # Filters unprocessed raw_messages
  #
  def self.unprocessed(limit)
    where(processed_at: nil).order(:captured_at).limit(limit)
  end

  # Finds the most recent 'viewed' message belonging to a visit
  def self.last_message_in_visit(url, username, heartbeat_id)
    where(url: url, username: username, heartbeat_id: heartbeat_id).order(captured_at: :desc).first
  end

  #
  # Creates a VideoVisit out of a RawMessage with the proper verb
  #
  # @return true/false whether raw_message was/wasn't correctly processed
  #
  def process_as_video
    video = Video.find_or_create_by!(url: video_id)

    visualization =
      video.visualizations.find_or_create_by!(session_id: session_id).tap do |v|
      v.page = linked_page
      v.user = linked_user
    end

    visualization.update_stats(captured_at, action['state'])

    update!(processed_at: Time.now)
  end

  #
  # Creates a Visit out of a RawMessage with the proper verb.
  # It may also update the record if it's a visit in progress
  #
  # @return true/false whether raw_message was/wasn't correctly processed
  #
  def process_as_page
    page = Page.find_or_create_by!(url: url) do |page|
      page.display_name = page_title
    end

    visit = page.visits.find_or_initialize_by(heartbeat_id: heartbeat_id)
    visit.update_attributes!(time_active: time,
                             date_visited: captured_at,
                             user: linked_user)

    update(processed_at: Time.now)
  end

  private

  def linked_user
    Organization.find_or_create_user(org_api_key, username)
  end

  def linked_page
    Page.find_or_create_by(url: url)
  end

  #
  # TODO: Why do we have this json 'action' column. Isn't it easier to user
  # properly typed columns for each attribute?
  #
  def video_id
    action['video_id']
  end

  def session_id
    action['session_id']
  end

  def time
    action['time']
  end
end
