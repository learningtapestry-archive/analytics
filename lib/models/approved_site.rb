class ApprovedSite < ActiveRecord::Base
  belongs_to :site
  belongs_to :district
  belongs_to :school
  belongs_to :section
end
