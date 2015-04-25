require 'chronic'
require 'chronic_duration'

class VideoView < ActiveRecord::Base
  #
  # TODO: Add a validation on user?
  #
  belongs_to :user

  belongs_to :page

  has_one :student, through: :user
  has_one :staff_member, through: :user
  has_one :site, through: :page
  has_one :site_visited, through: :site

  delegate :url, :to => :page

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
      video_views.date_started,
      video_views.date_ended,
      video_views.paused_count
    FROM
      video_views,
      organizations,
      users,
      videos
    WHERE
      video_views.user_id = users.id AND
      users.organization_id = organizations.id AND
      video_views.video_id = videos.id AND
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
