class ApprovedSite < ActiveRecord::Base
	has_many :approved_site_actions
end
