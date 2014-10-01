require 'uri'

class Site < ActiveRecord::Base
  has_many :site_visits
  has_many :pages
  # has_many :pages_visited, through: :pages, 
  #   select: 'distinct (pages_visited.id, sites_visited.user_id), pages_visited.*', 
  #   conditions: proc {["pages_visited.user_id = sites_visited.user_id"]}

  after_initialize :set_defaults

  def self.url_to_canonical(url)
    URI::parse(url).host
  end

  # legacy synonym
  def site_name
    self.display_name
  end

  def display_name
    super || url
  end

  def set_defaults
    # only set defaults for new records (ones not saved to db yet)
    return if persisted?
    # generate a random uuid if our new record doesn't have one
    if ((self.has_attribute?(:site_uuid)) && (self.site_uuid.nil?)) then
      self.site_uuid=SecureRandom.uuid
    end
  end

end
