class CreateStatementTable < ActiveRecord::Migration
  def up
  	create_table :statements do |t|
  		t.integer :user_id, null: false
  		t.string :actor, null: false, length: 1024
  		t.string :verb, null: false, length: 1024
  		t.string :object, null: false, length: 1024
  		t.string :context, length: 1024
  		t.string :result_string, length: 65000
  		t.float :result_number
  		t.datetime :result_datetime
  		t.datetime :date_captured
  		t.datetime :date_created
  		t.datetime :date_updated
  	end
  end

  def down
  	drop_table :statements
  end
end
