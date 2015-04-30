require 'chronic'
require 'chronic_duration'

class Visualization < ActiveRecord::Base
  belongs_to :user
  has_one :profile, through: :user

  has_one :site, through: :page
  has_one :site_visited, through: :site

  belongs_to :video

  #
  # TODO: Is this intentional or is this a copy/paste from the Visit model
  # and it's supposed to link to a video? In the same message there's 2 urls
  # for videos: 'url' and 'video_id', so it actually makes sense to link this
  # to a page as well.
  #
  belongs_to :page
  delegate :url, to: :page

  validates :session_id, presence: true, length: { is: 36 }

  def update_stats(captured_at, state)
    case state
    when 'playing' then on_playing(captured_at)
    when 'ended' then on_ended(captured_at)
    when 'pause' then on_pause(captured_at)
    end

    save!
  end

  def self.find(params = {})
    sql = "
    SELECT
      videos.title,
      videos.url,
      videos.publisher,
      users.username,
      visualizations.date_started,
      visualizations.date_ended,
    FROM
      visualizations,
      organizations,
      users,
      videos
    WHERE
      visualizations.user_id = users.id AND
      users.organization_id = organizations.id AND
      visualizations.video_id = videos.id AND
      organizations.org_api_key='#{params[:org_api_key]}' "

    if params[:date_started] != nil
      sql = sql + "AND time_started>='#{params[:date_started]}'"
    end

    if params[:date_ended] != nil
      sql = sql + "AND time_ended<='#{params[:date_ended]}'"
    end

    self.connection.select_all(sql)
  end

  private

  def on_ended(datetime)
    self.date_ended = datetime

    on_pause(datetime)
  end

  def on_playing(datetime)
    self.date_started, self.date_fragment_started = datetime, datetime
  end

  def on_pause(datetime)
    return unless date_fragment_started

    self.time_viewed += (datetime - date_fragment_started).to_i
    self.date_fragment_started = nil
  end
end
