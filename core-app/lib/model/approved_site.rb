class ApprovedSite < ActiveRecord::Base
	has_many :extraction_maps
end
