class ApprovedSite < ActiveRecord::Base
	has_many :approved_site_actions

  def self.get_by_site_hash(site_hash)
    ApprovedSite.where(:site_hash => site_hash).first
  end

  def self.get_all_with_actions
    ApprovedSite.all.as_json(
      include: { approved_site_actions: { except: [:updated_at, :created_at, :id, :approved_site_id] }}, 
      except: [:updated_at, :created_at, :id, :logo_url_small, :logo_url_large])
  end
end