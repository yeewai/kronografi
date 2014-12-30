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

ActiveRecord::Schema.define(version: 20141230051623) do

  create_table "aliases", force: :cascade do |t|
    t.string   "name"
    t.integer  "character_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "aliases", ["character_id"], name: "index_aliases_on_character_id"

  create_table "characters", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.integer  "age"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "characters_events", id: false, force: :cascade do |t|
    t.integer "character_id"
    t.integer "event_id"
  end

  add_index "characters_events", ["character_id"], name: "index_characters_events_on_character_id"
  add_index "characters_events", ["event_id"], name: "index_characters_events_on_event_id"

  create_table "events", force: :cascade do |t|
    t.text     "summary"
    t.text     "details"
    t.date     "happened_on"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "happened_key"
  end

  create_table "events_tags", id: false, force: :cascade do |t|
    t.integer "event_id"
    t.integer "tag_id"
  end

  add_index "events_tags", ["event_id"], name: "index_events_tags_on_event_id"
  add_index "events_tags", ["tag_id"], name: "index_events_tags_on_tag_id"

  create_table "media", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "content_file_name"
    t.string   "content_content_type"
    t.integer  "content_file_size"
    t.datetime "content_updated_at"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "content"
    t.text     "description"
    t.string   "slug"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
