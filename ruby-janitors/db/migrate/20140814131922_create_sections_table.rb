class CreateSectionsTable < ActiveRecord::Migration
  def up
  	create_table :sections do |t|
  		t.string :section_code
      t.integer :course_offering_id, null: false
  		t.string :sis_id
  		t.string :other_id
  		t.string :name, null: false
  		t.datetime :date_created
  		t.datetime :date_updated
  	end
  end

  def down
  	drop_table :sections
  end
end
