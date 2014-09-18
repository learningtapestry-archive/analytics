class ApprovedSite < ActiveRecord::Base
	has_many :approved_site_actions

  def self.get_by_site_hash(site_hash)
    ApprovedSite.where(:site_hash => site_hash).first
  end
end
