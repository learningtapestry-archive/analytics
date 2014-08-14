class CreateCoursesTable < ActiveRecord::Migration
  def up
  	create_table :courses do |t|
  		t.string :course_code
  		t.string :sis_id
  		t.string :other_id
  		t.string :name, null: false
  		t.string :description, length: 1024
  		t.string :subject_area
  		t.boolean :high_school_requirement
  		t.datetime :date_created
  		t.datetime :date_updated
  	end
  end

  def down
  	drop_table :courses
  end
end
