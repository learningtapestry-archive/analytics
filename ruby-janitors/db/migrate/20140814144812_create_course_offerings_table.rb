class CreateCourseOfferingsTable < ActiveRecord::Migration
  def up
  	create_table :course_offerings do |t|
  		t.integer :course_id, null: false
  		t.string :sis_id
  		t.string :other_id
      t.date :date_start
      t.date :date_end
  		t.datetime :date_created
  		t.datetime :date_updated
  	end
  end

  def down
  	drop_table :course_offerings
  end
end
