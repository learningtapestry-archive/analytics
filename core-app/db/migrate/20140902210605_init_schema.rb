class InitSchema < ActiveRecord::Migration
  def change

    ### Begin Message Collection Tables

    create_table "api_keys", :force => true do |t|
      t.string   "key",          :null => false
      t.belongs_to  :user,       :null => false
      t.timestamps
    end

    create_table "organizations", :force => true do |t|
      t.string "org_api_key"
    end

    create_table "raw_messages", :force => true do |t|
      t.string   "api_key"
      t.integer  "user_id"
      t.string   "org_api_key"
      t.string   "username"
      t.string   "page_title"
      t.uuid     "site_uuid"
      t.string   "verb"
      t.json     "action"
      t.string   "url",              :limit => 4096
      t.datetime "captured_at"
      t.belongs_to  :user
      t.timestamps
    end

    create_table "raw_message_logs", :force => true do |t|
      t.string "action"
      t.belongs_to :raw_message
      t.timestamps
    end

    ### End Message Collection Tables

    ### Begin Monitored Sites Tables

    create_table "sites", :force => true do |t|
      t.string   "url",             :null => false, :limit => 4096
      t.string   "display_name"
      t.uuid     "site_uuid",       :null => false
      t.string   "logo_url_small",  :limit => 4096
      t.string   "logo_url_large",  :limit => 4096
      t.timestamps
    end

    add_index :sites, :url, :unique => true

    create_table "site_actions", :force => true do |t|
      t.string   "action_type",     :null => false # CLICK, PAGEVIEW, EXTRACT 
      t.string   "url_pattern",     :null => false, :limit => 4096
      t.string   "css_selector"
      t.belongs_to  :site
      t.timestamps
    end

    create_table "approved_sites", :force => true do |t|
      t.belongs_to :site,           :null => false, :index => true
      t.belongs_to :district
      t.belongs_to :school
      t.belongs_to :section
      # Potentially course and user, but for the future if needed
      t.timestamps
    end

    ### End Monitored Sites Tables

    ### Begin Collected Data Schemantic Tables

    create_table "pages", :force => true do |t|
      t.string   "url",         :null => false, :limit => 4096
      t.string   "display_name"
      t.belongs_to :site
      t.timestamps
    end

    add_index :pages, :url, :unique => true

    create_table "page_visits", :force => true do |t|
      t.datetime "date_visited"
      t.column   "time_active", :interval
      t.belongs_to :user
      t.belongs_to :page
    end

    create_table "page_clicks", :force => true do |t|
      t.datetime "date_visited"
      t.string   "url_visited", :limit => 4096
      t.belongs_to :user
      t.belongs_to :page  # In future, this will belong to page_visits once relationships figured out
    end

    ### End Collected Data Schemantic Tables

    ### Begin Education Organization and Course Tables

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
      t.belongs_to :district
      t.timestamps
    end
    
    create_table "courses", :force => true do |t|
      t.string   "course_code"
      t.string   "sis_id"
      t.string   "other_id"
      t.string   "name",         :null => false
      t.string   "description"
      t.string   "subject_area"
      t.boolean  "high_school_requirement"
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

    create_table "sections", :force => true do |t|
      t.string   "section_code"
      t.integer  "course_offering_id"
      t.string   "sis_id"
      t.string   "other_id"
      t.string   "name",         :null => false
      t.timestamps
    end

    create_table "section_users", :force => true do |t|
      t.string   "user_type" # defines type of relationship user has to section (e.g.: "teacher" "student" "TA" "auditing")
      t.belongs_to :section
      t.belongs_to :user
    end

    ### End Education Organization and Course Tables

    ### Begin User Tables

    create_table "users", :force => true do |t|
      t.string   "first_name",    :null => false
      t.string   "middle_name"
      t.string   "last_name",     :null => false
      t.string   "gender"
      t.string   "username",     :null => false
      t.string   "password_digest"
      t.date     "date_of_birth"
      t.belongs_to  :school
      t.timestamps
    end

    add_index :users, :username, :unique => true

    create_table "emails", :force => true do |t|
      t.string   "email"
      t.boolean  "primary"
      t.belongs_to :user
    end

    create_table "students", :force => true do |t|
      t.string   "state_id"
      t.string   "sis_id"
      t.string   "other_id"
      t.string   "grade_level"
      t.belongs_to :user
      t.timestamps
    end

    create_table "staff_members", :force => true do |t|
      t.string   "state_id"
      t.string   "sis_id"
      t.string   "other_id"
      t.string   "staff_member_type", :null => false
      t.belongs_to :user
      t.timestamps
    end 

    ### End User Tables

  end #def change
end # class migration
