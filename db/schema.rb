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

ActiveRecord::Schema.define(version: 20150401031008) do

  create_table "aliases", force: :cascade do |t|
    t.string   "name"
    t.integer  "concept_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "world_id",   default: 1, null: false
  end

  add_index "aliases", ["concept_id"], name: "index_aliases_on_concept_id"
  add_index "aliases", ["world_id"], name: "index_aliases_on_world_id"

  create_table "concepts", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.integer  "age"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "world_id",            default: 1,      null: false
    t.integer  "user_id"
    t.string   "kind",                default: "misc"
  end

  add_index "concepts", ["world_id"], name: "index_concepts_on_world_id"

  create_table "concepts_events", id: false, force: :cascade do |t|
    t.integer "concept_id"
    t.integer "event_id"
  end

  add_index "concepts_events", ["concept_id"], name: "index_concepts_events_on_concept_id"
  add_index "concepts_events", ["event_id"], name: "index_concepts_events_on_event_id"

  create_table "events", force: :cascade do |t|
    t.text     "summary"
    t.text     "details"
    t.datetime "happened_on"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "happened_key"
    t.integer  "world_id",     default: 1,         null: false
    t.string   "kind",         default: "regular", null: false
    t.integer  "user_id"
  end

  add_index "events", ["world_id"], name: "index_events_on_world_id"

  create_table "events_tags", id: false, force: :cascade do |t|
    t.integer "event_id"
    t.integer "tag_id"
  end

  add_index "events_tags", ["event_id"], name: "index_events_tags_on_event_id"
  add_index "events_tags", ["tag_id"], name: "index_events_tags_on_tag_id"

  create_table "gars", force: :cascade do |t|
    t.string   "name"
    t.text     "value"
    t.text     "url"
    t.string   "ipaddress"
    t.string   "user_agent"
    t.text     "referer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "content_file_name"
    t.string   "content_content_type"
    t.integer  "content_file_size"
    t.datetime "content_updated_at"
  end

  create_table "rulings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "world_id"
    t.string   "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "content"
    t.text     "description"
    t.string   "slug"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "world_id",    default: 1, null: false
  end

  add_index "tags", ["world_id"], name: "index_tags_on_world_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "name"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

  create_table "worlds", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "token"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "user_id"
    t.string   "scale",       default: "years"
    t.boolean  "is_absolute", default: true
    t.boolean  "is_public",   default: false
  end

end
