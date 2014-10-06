class ApprovedSite < ActiveRecord::Base
	has_many :sites
  has_many :schools
  has_many :districts

  def self.get_all_with_actions
    Site.all.as_json(
      include: { site_actions: { except: [:updated_at, :created_at, :id, :approved_site_id] }}, 
      except: [:updated_at, :created_at, :id, :logo_url_small, :logo_url_large]
      )
  end

  def self.get_with_actions_by_school(school)
    Site.joins(:approved_sites)
    .where(approved_sites: { school_id: school.id })
    .as_json(
      include: { site_actions: { except: [:updated_at, :created_at, :id, :approved_site_id] }}, 
      except: [:updated_at, :created_at, :id, :logo_url_small, :logo_url_large]
      )
  end
end