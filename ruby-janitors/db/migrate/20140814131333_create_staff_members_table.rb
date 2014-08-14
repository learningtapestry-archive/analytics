class CreateStaffMembersTable < ActiveRecord::Migration
  def up
  	create_table :staff_members do |t|
  		t.string :state_id
  		t.string :sis_id
  		t.string :other_id
  		t.string :staff_member_type, null: false
  		t.string :first_name, null: false
  		t.string :middle_name
  		t.string :last_name, null: false
  		t.string :gender
  		t.string :login
  		t.string :password
  		t.string :email
  		t.date :date_of_birth
  		t.datetime :date_created
  		t.datetime :date_updated
  	end
  end

  def down
  	drop_table :staff_members
  end
end
