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

ActiveRecord::Schema.define(version: 20141109063413) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alignments", force: true do |t|
    t.text     "framework"
    t.text     "name"
    t.text     "type"
    t.text     "description"
    t.text     "url"
    t.text     "hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: true do |t|
    t.string   "doc_id"
    t.text     "file_location"
    t.text     "doc_type"
    t.text     "resource_locator"
    t.text     "resource_data"
    t.text     "resource_data_type"
    t.text     "keys"
    t.text     "tos"
    t.text     "revision"
    t.text     "payload_schema_locator"
    t.text     "payload_placement"
    t.text     "payload_schema"
    t.text     "node_timestamp"
    t.text     "digital_signature"
    t.text     "create_timestamp"
    t.text     "doc_version"
    t.text     "identity"
    t.text     "full_record"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "identity_id"
  end

  create_table "documents_alignments", id: false, force: true do |t|
    t.integer "document_id",  null: false
    t.integer "alignment_id", null: false
  end

  create_table "documents_payload_schemas", id: false, force: true do |t|
    t.integer "document_id",       null: false
    t.integer "payload_schema_id", null: false
  end

  create_table "documents_tags", id: false, force: true do |t|
    t.integer "document_id", null: false
    t.integer "tag_id",      null: false
  end

  create_table "identities", force: true do |t|
    t.text     "submitter"
    t.text     "submitter_type"
    t.text     "curator"
    t.text     "signer"
    t.text     "owner"
    t.text     "hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payload_schemas", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
