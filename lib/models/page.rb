require 'uri'

#
# A Web page
#
class Page < ActiveRecord::Base
  has_many :visits, class_name: 'PageVisit'
  belongs_to :site

  def url=(value)
    self[:url] = value
    return unless value

    self.site = Site.find_or_create_by(url: URI(value).host)
  end
end
