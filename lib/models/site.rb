require 'uri'

require 'models/concerns/summarizable'

class Site < ActiveRecord::Base
  has_many :pages

  has_many :site_actions
  accepts_nested_attributes_for :site_actions

  has_many :approved_sites

  # has_many :pages_visited, through: :pages,
  #   select: 'distinct (pages_visited.id, sites_visited.user_id), pages_visited.*',
  #   conditions: proc {["pages_visited.user_id = sites_visited.user_id"]}

  after_initialize :set_defaults

  def self.url_to_canonical(url)
    URI::parse(url).host
  end

  #
  # Legacy synonym
  #
  alias_attribute :site_name, :display_name

  def display_name
    self[:display_name] || url
  end

  def set_defaults
    # only set defaults for new records (ones not saved to db yet)
    return if persisted?
    # generate a random uuid if our new record doesn't have one
    if ((self.has_attribute?(:site_uuid)) && (self.site_uuid.nil?)) then
      self.site_uuid=SecureRandom.uuid
    end
  end

  def self.get_all_with_actions
    site_action_opts = {
      except: [:updated_at, :created_at, :id, :approved_site_id]
    }

    all.as_json(
      include: { site_actions: site_action_opts },
      except: [:updated_at, :created_at, :id, :logo_url_small, :logo_url_large]
    )
  end

  extend Summarizable

  def self.grouped_summary(user, opts)
    base_grouped_summary(user, opts)
  end

  def self.join_visits
    joins(pages: :visits)
  end
end
