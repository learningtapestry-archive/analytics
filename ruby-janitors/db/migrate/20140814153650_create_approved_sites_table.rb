class CreateApprovedSitesTable < ActiveRecord::Migration
  def up
  	create_table :approved_sites do |t|
  		t.string :hash_id, null: false
  		t.string :url_pattern, null: false
  		t.string :css_selector, null: false
  		t.datetime :date_created
  		t.datetime :date_updated
  	end
  end

  def down
  	drop_table :approved_sites
  end
end
