require 'uri'

#
# A video on the Internet
#
class Video < ActiveRecord::Base
  has_many :views, class_name: 'VideoView'
  belongs_to :site

  validates :url, presence: true

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
end
