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

ActiveRecord::Schema.define(version: 20140901120947) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: true do |t|
    t.string   "attachment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments_messages", force: true do |t|
    t.integer "attachment_id"
    t.integer "message_id"
  end

  add_index "attachments_messages", ["attachment_id"], name: "index_attachments_messages_on_attachment_id", using: :btree
  add_index "attachments_messages", ["message_id"], name: "index_attachments_messages_on_message_id", using: :btree

  create_table "config_items", force: true do |t|
    t.string   "key"
    t.text     "value"
    t.text     "default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "read_at"
    t.integer  "author_id"
  end

  add_index "messages", ["author_id"], name: "index_messages_on_author_id", using: :btree
  add_index "messages", ["topic_id"], name: "index_messages_on_topic_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.datetime "read_at"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "object_id"
    t.string   "object_type"
  end

  add_index "notifications", ["object_id", "object_type"], name: "index_notifications_on_object_id_and_object_type", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "orders", force: true do |t|
    t.text     "cart_order"
    t.datetime "payment_date"
    t.integer  "orderable_id",   null: false
    t.string   "orderable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pim_offerings", force: true do |t|
    t.string   "offering_id",       null: false
    t.string   "offering_price_id", null: false
    t.string   "text",              null: false
    t.float    "amount",            null: false
    t.string   "unit"
    t.integer  "unit_qty"
    t.string   "type"
    t.integer  "user_id"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recoveries", force: true do |t|
    t.string   "phone"
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", force: true do |t|
    t.string   "phone"
    t.string   "ogrn"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "workflow_state"
    t.boolean  "admin_notified", default: false
    t.string   "inn"
    t.string   "company_name"
    t.string   "region_code"
    t.text     "uas_user"
    t.string   "password"
    t.string   "contact_id"
    t.string   "person_id"
    t.integer  "user_id"
  end

  create_table "search_queries", force: true do |t|
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_queries", ["user_id"], name: "index_search_queries_on_user_id", using: :btree

  create_table "shortcuts", force: true do |t|
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms_verifications", force: true do |t|
    t.string   "cookie"
    t.string   "code"
    t.integer  "attempts"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "topics", force: true do |t|
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.string   "widget_type"
    t.text     "widget_options"
    t.datetime "read_at"
  end

  add_index "topics", ["author_id"], name: "index_topics_on_author_id", using: :btree
  add_index "topics", ["user_id"], name: "index_topics_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "siebel_id"
    t.string   "integration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_concierge",       default: false
    t.integer  "concierge_id"
    t.string   "api_token"
    t.boolean  "approved",           default: false
    t.string   "tax_treatment"
    t.boolean  "is_super_concierge", default: false
    t.datetime "last_activity_at"
  end

  add_index "users", ["api_token"], name: "index_users_on_api_token", using: :btree
  add_index "users", ["concierge_id"], name: "index_users_on_concierge_id", using: :btree
  add_index "users", ["integration_id"], name: "index_users_on_integration_id", using: :btree
  add_index "users", ["siebel_id"], name: "index_users_on_siebel_id", using: :btree

end
