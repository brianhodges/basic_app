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

ActiveRecord::Schema.define(version: 20161106221501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "roles", force: :cascade do |t|
    t.string   "role",       default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "user_images", force: :cascade do |t|
    t.string   "filename",     default: "", null: false
    t.string   "content_type", default: "", null: false
    t.binary   "data"
    t.integer  "user_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "user_images", ["user_id"], name: "index_user_images_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",            default: "", null: false
    t.string   "password_hash",    default: "", null: false
    t.string   "password_salt",    default: "", null: false
    t.integer  "role_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "profile_image_id"
    t.string   "first_name",       default: "", null: false
    t.string   "last_name",        default: "", null: false
  end

  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

  add_foreign_key "user_images", "users"
  add_foreign_key "users", "roles"
end
