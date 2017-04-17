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

ActiveRecord::Schema.define(version: 2017041702) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string   "key",        null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "approved_sites", force: :cascade do |t|
    t.integer  "site_id",     null: false
    t.integer  "district_id"
    t.integer  "school_id"
    t.integer  "section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "approved_sites", ["site_id"], name: "index_approved_sites_on_site_id", using: :btree

  create_table "course_offerings", force: :cascade do |t|
    t.integer  "course_id",  null: false
    t.string   "sis_id"
    t.string   "other_id"
    t.date     "date_start"
    t.date     "date_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: :cascade do |t|
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

  create_table "districts", force: :cascade do |t|
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

  create_table "emails", force: :cascade do |t|
    t.string   "email"
    t.boolean  "primary"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "org_api_key"
    t.string   "org_secret_key"
    t.integer  "invalid_logins", default: 0
    t.boolean  "locked",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["org_api_key"], name: "index_organizations_on_org_api_key", using: :btree

  create_table "page_clicks", force: :cascade do |t|
    t.datetime "date_visited"
    t.text     "url_visited"
    t.integer  "user_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: :cascade do |t|
    t.text     "url",          null: false
    t.string   "display_name"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["url"], name: "index_pages_on_url", unique: true, using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "state_id"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "type"
    t.string   "grade_level"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "raw_messages", force: :cascade do |t|
    t.string   "api_key"
    t.string   "org_api_key"
    t.integer  "user_id"
    t.string   "username"
    t.string   "page_title"
    t.uuid     "site_uuid"
    t.integer  "verb"
    t.json     "action"
    t.text     "url"
    t.datetime "captured_at"
    t.datetime "processed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.string   "heartbeat_id"
    t.boolean  "processable"
  end

  add_index "raw_messages", ["captured_at"], name: "index_raw_messages_on_captured_at", order: {"captured_at"=>:desc}, using: :btree
  add_index "raw_messages", ["heartbeat_id"], name: "index_raw_messages_on_heartbeat_id", using: :btree
  add_index "raw_messages", ["processed_at"], name: "index_raw_messages_on_processed_at", using: :btree
  add_index "raw_messages", ["url"], name: "index_raw_messages_on_url", using: :btree
  add_index "raw_messages", ["username"], name: "index_raw_messages_on_username", using: :btree
  add_index "raw_messages", ["verb"], name: "idx_raw_messages_extractor", where: "((processed_at IS NULL) AND (processable IS NULL))", using: :btree
  add_index "raw_messages", ["verb"], name: "index_raw_messages_on_verb", using: :btree

  create_table "schools", force: :cascade do |t|
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

  create_table "section_users", force: :cascade do |t|
    t.integer  "section_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: :cascade do |t|
    t.string   "section_code"
    t.integer  "course_offering_id"
    t.string   "sis_id"
    t.string   "other_id"
    t.string   "name",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_actions", force: :cascade do |t|
    t.string   "action_type",  null: false
    t.text     "url_pattern",  null: false
    t.string   "css_selector"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", force: :cascade do |t|
    t.text     "url",            null: false
    t.string   "display_name"
    t.uuid     "site_uuid",      null: false
    t.text     "logo_url_small"
    t.text     "logo_url_large"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sites", ["url"], name: "index_sites_on_url", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
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

  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree
  add_index "users", ["username", "organization_id"], name: "index_users_on_username_and_organization_id", unique: true, using: :btree
  add_index "users", ["username"], name: "idx_users_username_any", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, where: "(organization_id IS NULL)", using: :btree

  create_table "videos", force: :cascade do |t|
    t.text     "service_id"
    t.text     "external_id"
    t.text     "url",                      null: false
    t.text     "title"
    t.text     "description"
    t.text     "publisher"
    t.text     "category"
    t.string   "video_length"
    t.integer  "views",          limit: 8
    t.integer  "like_count",     limit: 8
    t.integer  "dislike_count",  limit: 8
    t.integer  "favorite_count", limit: 8
    t.integer  "comment_count",  limit: 8
    t.datetime "published_on"
    t.datetime "updated_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visits", force: :cascade do |t|
    t.datetime "date_visited"
    t.integer  "time_active",  default: 0
    t.integer  "user_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "heartbeat_id"
  end

  add_index "visits", ["date_visited"], name: "index_visits_on_date_visited", using: :btree
  add_index "visits", ["page_id", "heartbeat_id"], name: "index_visits_on_page_id_and_heartbeat_id", unique: true, using: :btree
  add_index "visits", ["page_id"], name: "index_visits_on_page_id", using: :btree
  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

  create_table "visualizations", force: :cascade do |t|
    t.datetime "date_started"
    t.datetime "date_ended"
    t.datetime "date_fragment_started"
    t.integer  "time_viewed",           default: 0
    t.string   "session_id"
    t.integer  "user_id"
    t.integer  "video_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
