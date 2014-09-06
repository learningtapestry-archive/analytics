class InitSchema < ActiveRecord::Migration
  def change
    create_table "approved_sites", :force => true do |t|
      t.string   "hash_id",      :null => false
      t.string   "url_pattern",  :null => false
      t.string   "css_selector", :null => false
      t.timestamps
    end
    
    create_table "status", :force => true do |t|
      t.string "status_type" # what are the status of the rows
      t.string "worker_type" # what extractor is it?
      t.string "job_id"      # what specific extractor 
    end

    create_table "raw_messages", :force => true do |t|
      t.integer  "status_id" # note this should probably be :null=>false once we have more code working
      t.string   "api_key",       :null => false
      t.string   "email",         :null => false
      t.string   "action"
      t.string   "event"
      t.string   "url"
      t.text     "html"
      t.datetime "captured_at"
      t.timestamps
    end
    
    create_table "schools", :force => true do |t|
      t.string   "state_id"
      t.string   "nces_id"
      t.string   "sis_id"
      t.string   "other_id"
      t.string   "name",         :null => false
      t.string   "address"
      t.string   "city"
      t.string   "state"
      t.string   "phone"
      t.string   "grade_low"
      t.string   "grade_high"
      t.timestamps
    end
    
    create_table "course_offerings", :force => true do |t|
      t.integer  "course_id",    :null => false
      t.string   "sis_id"
      t.string   "other_id"
      t.date     "date_start"
      t.date     "date_end"
      t.timestamps
    end
    
    create_table "courses", :force => true do |t|
      t.string   "course_code"
      t.string   "sis_id"
      t.string   "other_id"
      t.string   "name",                    :null => false
      t.string   "description"
      t.string   "subject_area"
      t.boolean  "high_school_requirement"
      t.timestamps
    end
    
    create_table "districts", :force => true do |t|
      t.string   "state_id"
      t.string   "nces_id"
      t.string   "sis_id"
      t.string   "other_id"
      t.string   "name",         :null => false
      t.string   "address"
      t.string   "city"
      t.string   "state"
      t.string   "phone"
      t.string   "grade_low"
      t.string   "grade_high"
      t.timestamps
    end

    create_table "sections", :force => true do |t|
      t.string   "section_code"
      t.integer  "course_offering_id", :null => false
      t.string   "sis_id"
      t.string   "other_id"
      t.string   "name",               :null => false
      t.timestamps
    end

    create_table "users", :force => true do |t|
      t.string   "first_name",    :null => false
      t.string   "middle_name"
      t.string   "last_name",     :null => false
      t.string   "gender"
      t.string   "username"
      t.string   "password"
      t.date     "date_of_birth"
      t.timestamps

    end

    add_index :users, :username, :unique => true

    create_table "emails", :force => true do |t|
      t.integer "user_id",     :null => false
      t.string   "email"
    end

    create_table "students", :force => true do |t|
      t.string   "state_id"
      t.string   "sis_id"
      t.string   "other_id"
      t.string   "grade_level"
      t.integer "user_id", :null => false
      t.timestamps
    end

    create_table "staff_members", :force => true do |t|
      t.string   "state_id"
      t.string   "sis_id"
      t.string   "other_id"
      t.string   "staff_member_type", :null => false
      t.integer "user_id", :null => false
      t.timestamps
    end 
  end #def change
end # class migration
