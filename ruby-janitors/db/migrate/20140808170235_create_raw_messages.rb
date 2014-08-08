class CreateRawMessages < ActiveRecord::Migration
  def up
  	create_table :raw_messages do |t|
  		t.string :status, null: false
  		t.string :api_key, null: false
  		t.string :email, null: false
  		t.string :action
  		t.string :url
  		t.string :html
  		t.date :date_captured
  		t.date :date_created
  		t.date :date_updated
  	end
  end

  def down
  	drop_table :raw_messages
  end
end

