require 'uri'

#
# A Web page
#
class Page < ActiveRecord::Base
  validates :url, presence: true

  has_many :visits, inverse_of: :page
  accepts_nested_attributes_for :visits

  belongs_to :site

  def url=(value)
    self[:url] = value
    return unless value

    self.site = Site.find_or_create_by(url: URI(value).host)
  end
end
