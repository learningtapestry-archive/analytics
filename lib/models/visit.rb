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

  scope :by_site_domains, -> (domain) { joins(page: :site).where(sites: {url: domain}) }

  scope :by_page_urls, -> (url) { joins(:page).where(pages: {url: url}) }

  scope :summary, lambda { |type|
    type == 'site_visits' ? summary_by_site : summary_by_page
  }

  scope :detail, -> (type) { type == 'site_visits' ? detail_by_site : detail_by_page }

  scope :summary_by_site, lambda {
    select('sites.display_name as site_name',
           'sites.url as site_domain',
           'users.username as username',
           'sum(time_active) as total_time')
      .joins(:user, page: :site)
      .group('sites.display_name', 'sites.url', 'users.username')
      .order('sites.url')
  }

  scope :detail_by_site, -> {
    select('sites.display_name as site_name',
           'sites.url as site_domain',
           'users.username as username',
           'time_active as total_time',
           'date_visited',
           'date_visited + time_active * interval \'1 second\' as date_left')
        .joins(:user, page: :site)
        .order('sites.url')
  }

  scope :summary_by_page, lambda {
    select('sites.display_name as site_name',
           'sites.url as site_domain',
           'pages.display_name as page_name',
           'pages.url as page_url',
           'users.username as username',
           'sum(time_active) as total_time')
      .joins(:user, page: :site)
      .group('sites.display_name',
             'sites.url',
             'pages.display_name',
             'pages.url',
             'users.username')
      .order('sites.url')
  }

  scope :detail_by_page, -> {
    detail_by_site.select('pages.display_name as page_name',
                          'pages.url as page_url')
  }
end
