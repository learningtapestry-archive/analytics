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
  # Maximum number of messages to be processed by the same janitor
  #
  MAX_TRANSACTION_LENGTH = 2000

  #
  # Video visits yet to be processed into VideoVisit objects
  #
  def self.video_msgs(limit = MAX_TRANSACTION_LENGTH)
    video_action.unprocessed(limit)
  end

  #
  # Page visits yet to be processed into Visit objects
  #
  def self.page_msgs(limit = MAX_TRANSACTION_LENGTH)
    viewed.unprocessed(limit)
  end

  #
  # Filters unprocessed raw_messages
  #
  def self.unprocessed(limit = MAX_TRANSACTION_LENGTH)
    where(processed_at: nil).order(:captured_at).limit(limit)
  end

  #
  # Creates a VideoVisit out of a RawMessage with the proper verb
  #
  # @return true/false whether raw_message was/wasn't correctly processed
  #
  def process_as_video
    video = Video.find_or_create_by(url: action['video_id'])
    return false unless video.valid?

    view =
      video.views.find_or_create_by(session_id: action['session_id']).tap do |v|
        v.page = linked_page
        v.user = linked_user
      end
    return false unless view.valid?

    view.update_stats(captured_at, action['state'])

    update(processed_at: Time.now)
  end

  #
  # Creates a Visit out of a RawMessage with the proper verb
  #
  # @return true/false whether raw_message was/wasn't correctly processed
  #
  def process_as_page
    page = Page.find_or_create_by(url: url) do |page|
      page.display_name = page_title
    end
    return false unless page.valid?

    page_visit = page.visits.create(
      time_active: action['time'],
      date_visited: captured_at,
      user: linked_user)
    return false unless page_visit.valid?

    update(processed_at: Time.now)
  end

  private

  def linked_user
    Organization.find_or_create_user(org_api_key, username)
  end

  def linked_page
    Page.find_or_create_by(url: url)
  end
end
