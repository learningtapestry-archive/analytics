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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: true do |t|
    t.string   "key",        null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "approved_sites", force: true do |t|
    t.integer  "site_id",     null: false
    t.integer  "district_id"
    t.integer  "school_id"
    t.integer  "section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "approved_sites", ["site_id"], name: "index_approved_sites_on_site_id", using: :btree

  create_table "course_offerings", force: true do |t|
    t.integer  "course_id",  null: false
    t.string   "sis_id"
    t.string   "other_id"
    t.date     "date_start"
    t.date     "date_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "course_code"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "name",                    null: false
    t.string   "description"
    t.string   "subject_area"
    t.boolean  "high_school_requirement"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", force: true do |t|
    t.string   "state_id"
    t.string   "nces_id"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "name",       null: false
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "phone"
    t.string   "grade_low"
    t.string   "grade_high"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: true do |t|
    t.string   "email"
    t.boolean  "primary"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "org_api_key"
    t.string   "org_secret_key"
    t.integer  "invalid_logins", default: 0
    t.boolean  "locked",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_clicks", force: true do |t|
    t.datetime "date_visited"
    t.text     "url_visited"
    t.integer  "user_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_visits", force: true do |t|
    t.datetime "date_visited"
    t.string   "time_active"
    t.integer  "user_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: true do |t|
    t.text     "url",          null: false
    t.string   "display_name"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["url"], name: "index_pages_on_url", unique: true, using: :btree

  create_table "raw_document_logs", force: true do |t|
    t.string   "action"
    t.date     "newest_import_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "raw_documents", force: true do |t|
    t.string   "doc_id"
    t.boolean  "active"
    t.string   "doc_type"
    t.string   "doc_version"
    t.text     "identity"
    t.text     "keys"
    t.string   "payload_placement"
    t.text     "payload_schema"
    t.json     "resource_data_json"
    t.xml      "resource_data_xml"
    t.text     "resource_data_string"
    t.string   "resource_data_type"
    t.string   "resource_locator"
    t.text     "raw_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "raw_documents", ["doc_id"], name: "index_raw_documents_on_doc_id", unique: true, using: :btree

  create_table "raw_message_logs", force: true do |t|
    t.string   "action"
    t.integer  "raw_message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "raw_messages", force: true do |t|
    t.string   "api_key"
    t.string   "org_api_key"
    t.integer  "user_id"
    t.string   "username"
    t.string   "page_title"
    t.uuid     "site_uuid"
    t.string   "verb"
    t.json     "action"
    t.text     "url"
    t.datetime "captured_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
  end

  create_table "schools", force: true do |t|
    t.string   "state_id"
    t.string   "nces_id"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "name",        null: false
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "phone"
    t.string   "grade_low"
    t.string   "grade_high"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "section_users", force: true do |t|
    t.string   "user_type"
    t.integer  "section_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: true do |t|
    t.string   "section_code"
    t.integer  "course_offering_id"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "name",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_actions", force: true do |t|
    t.string   "action_type",  null: false
    t.text     "url_pattern",  null: false
    t.string   "css_selector"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", force: true do |t|
    t.text     "url",            null: false
    t.string   "display_name"
    t.uuid     "site_uuid",      null: false
    t.text     "logo_url_small"
    t.text     "logo_url_large"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sites", ["url"], name: "index_sites_on_url", unique: true, using: :btree

  create_table "staff_members", force: true do |t|
    t.string   "state_id"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "staff_member_type", null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: true do |t|
    t.string   "state_id"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "grade_level"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "username",        null: false
    t.string   "password_digest"
    t.date     "date_of_birth"
    t.integer  "school_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username", "organization_id"], name: "index_users_on_username_and_organization_id", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, where: "(organization_id IS NULL)", using: :btree

end
