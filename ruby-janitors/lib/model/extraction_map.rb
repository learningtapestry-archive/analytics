class ExtractionMap < ActiveRecord::Base
	belongs_to :approved_sites
	has_many :child_extraction_maps, class_name: "ExtractionMap", foreign_key: "parent_extraction_map_id"
end
