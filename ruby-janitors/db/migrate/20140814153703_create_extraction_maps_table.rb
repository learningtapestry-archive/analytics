class CreateExtractionMapsTable < ActiveRecord::Migration
  def up
  	create_table :extraction_maps do |t|
  		t.belongs_to :approved_site, null: false
  		t.string :target_field
      t.string :css_selector, null: false
      t.integer :parent_extraction_map_id
  		t.datetime :date_created
  		t.datetime :date_updated
  	end
  end

  def down
  	drop_table :extraction_maps
  end
end
