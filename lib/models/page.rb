require 'uri'

require 'models/concerns/summarizable'

#
# A Web page
#
class Page < ActiveRecord::Base
  validates :url, presence: true

  has_many :visits
  accepts_nested_attributes_for :visits

  belongs_to :site

  extend Summarizable

  def self.join_visits
    joins(:visits)
  end

  def self.grouped_summary(user, opts = {})
    base_grouped_summary(user, opts).where(site_id: opts[:site].id)
  end

  def url=(value)
    self[:url] = value
    return unless value

    self.site = Site.find_or_create_by(url: URI(value).host)
  end
end
