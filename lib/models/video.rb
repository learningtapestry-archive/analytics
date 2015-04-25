require 'uri'

class Video < ActiveRecord::Base
  has_many :video_views
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

  def video_view_from_raw_message(msg)
    video_views.find_or_create_by(session_id: msg.action['session_id']) do |vv|
      vv.page = Page.find_or_create_by(url: msg.url) if msg.url

      organization = Organization.find_by(org_api_key: msg.org_api_key)

      if organization && organization.users.any?
        vv.user = organization.users.find_or_create_by(username: msg.username)
      end
    end
  end
end
