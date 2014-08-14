class CreateDistrictsTable < ActiveRecord::Migration
  def up
  	create_table :districts do |t|
  		t.string :state_id
  		t.string :nces_id
  		t.string :sis_id
  		t.string :other_id
  		t.string :name, null: false
  		t.string :address
  		t.string :city
  		t.string :state
  		t.string :phone
  		t.string :grade_low
  		t.string :grade_high
  		t.datetime :date_created
  		t.datetime :date_updated
  	end
  end

  def down
  	drop_table :districts
  end
end
