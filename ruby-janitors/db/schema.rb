# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140814153703) do

  create_table "approved_sites", :force => true do |t|
    t.string   "hash_id",      :null => false
    t.string   "url_pattern",  :null => false
    t.string   "css_selector", :null => false
    t.datetime "date_created"
    t.datetime "date_updated"
  end

  create_table "course_offerings", :force => true do |t|
    t.integer  "course_id",    :null => false
    t.string   "sis_id"
    t.string   "other_id"
    t.date     "date_start"
    t.date     "date_end"
    t.datetime "date_created"
    t.datetime "date_updated"
  end

  create_table "courses", :force => true do |t|
    t.string   "course_code"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "name",                    :null => false
    t.string   "description"
    t.string   "subject_area"
    t.boolean  "high_school_requirement"
    t.datetime "date_created"
    t.datetime "date_updated"
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
    t.datetime "date_created"
    t.datetime "date_updated"
  end

  create_table "extraction_maps", :force => true do |t|
    t.integer  "approved_site_id",         :null => false
    t.string   "target_field"
    t.string   "css_selector",             :null => false
    t.integer  "parent_extraction_map_id"
    t.datetime "date_created"
    t.datetime "date_updated"
  end

  create_table "raw_messages", :force => true do |t|
    t.string   "status",        :null => false
    t.string   "api_key",       :null => false
    t.string   "email",         :null => false
    t.string   "action"
    t.string   "url"
    t.text     "html"
    t.datetime "date_captured"
    t.datetime "date_created"
    t.datetime "date_updated"
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
    t.datetime "date_created"
    t.datetime "date_updated"
  end

  create_table "sections", :force => true do |t|
    t.string   "section_code"
    t.integer  "course_offering_id", :null => false
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "name",               :null => false
    t.datetime "date_created"
    t.datetime "date_updated"
  end

  create_table "staff_members", :force => true do |t|
    t.string   "state_id"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "staff_member_type", :null => false
    t.string   "first_name",        :null => false
    t.string   "middle_name"
    t.string   "last_name",         :null => false
    t.string   "gender"
    t.string   "login"
    t.string   "password"
    t.string   "email"
    t.date     "date_of_birth"
    t.datetime "date_created"
    t.datetime "date_updated"
  end

  create_table "statements", :force => true do |t|
    t.integer  "user_id",         :null => false
    t.string   "actor",           :null => false
    t.string   "verb",            :null => false
    t.string   "object",          :null => false
    t.string   "context"
    t.string   "result_string"
    t.float    "result_number"
    t.datetime "result_datetime"
    t.datetime "date_captured"
    t.datetime "date_created"
    t.datetime "date_updated"
  end

  create_table "students", :force => true do |t|
    t.string   "state_id"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "first_name",    :null => false
    t.string   "middle_name"
    t.string   "last_name",     :null => false
    t.string   "gender"
    t.string   "login"
    t.string   "password"
    t.string   "email"
    t.string   "grade_level"
    t.date     "date_of_birth"
    t.datetime "date_created"
    t.datetime "date_updated"
  end

end
