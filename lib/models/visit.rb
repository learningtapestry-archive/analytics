require 'chronic_duration'

#
# Records a page visited by a user
#
class Visit < ActiveRecord::Base
  belongs_to :user
  has_one :profile, through: :user

  has_one :site, through: :page

  belongs_to :page
  validates :page, presence: true
  validates :heartbeat_id, uniqueness: { scope: :page_id }

  delegate :url, :display_name, to: :page

  def time_active=(value)
    self[:time_active] = ChronicDuration.parse(value).to_i
  end

  scope :by_dates, lambda { |date_begin, date_end|
    where("date_visited >= '#{date_begin}'")
      .where("date_visited <= '#{date_end}'")
  }

  scope :by_usernames, -> (usernames) { where(user: User.where(username: usernames)) }

  scope :summary, lambda { |type|
    type == 'site_visits' ? summary_by_site : summary_by_page
  }

  scope :summary_by_site, lambda {
    select('sites.display_name as site_name',
           'sites.url as site_domain',
           'sum(time_active) as total_time')
      .joins(page: :site)
      .group('sites.display_name', 'sites.url')
      .order('sites.url')
  }

  scope :summary_by_page, lambda {
    select('sites.display_name as site_name',
           'sites.url as site_domain',
           'pages.display_name as page_name',
           'pages.url as page_url',
           'sum(time_active) as total_time')
      .joins(page: :site)
      .group('sites.display_name',
             'sites.url',
             'pages.display_name',
             'pages.url')
      .order('sites.url')
  }
end
