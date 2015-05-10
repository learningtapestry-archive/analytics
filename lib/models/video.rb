require 'uri'

#
# A video on the Internet
#
class Video < ActiveRecord::Base
  validates :url, presence: true

  has_many :visualizations
  belongs_to :site

  scope :unprocessed, -> { where(title: nil, service_id: 'youtube') }

  def url=(string)
    self[:url] = string
    return unless string

    uri = URI(string)
    return unless uri.host.include?('youtube')

    self.service_id = 'youtube'
    uri.query.split('&').each do |param|
      next unless param.split('=').size == 2 && param.split('=')[0] == 'v'

      self.external_id = param.split('=')[1]
    end
  end

  def rating
    like_count - dislike_count
  end

  def raters
    like_count + dislike_count
  end
end
