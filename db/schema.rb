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

ActiveRecord::Schema.define(version: 20160916062727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rentals", force: :cascade do |t|
    t.datetime "pick_up_time"
    t.datetime "drop_off_time"
    t.integer  "customer_id"
    t.integer  "clerk_id"
    t.integer  "collector_id"
    t.integer  "vehicle_id"
    t.datetime "actual_drop_off_time"
    t.integer  "odometer"
    t.integer  "fuel_level"
    t.integer  "primary_driver_id"
  end

  add_index "rentals", ["clerk_id"], name: "index_rentals_on_clerk_id", using: :btree
  add_index "rentals", ["collector_id"], name: "index_rentals_on_collector_id", using: :btree
  add_index "rentals", ["customer_id"], name: "index_rentals_on_customer_id", using: :btree
  add_index "rentals", ["primary_driver_id"], name: "index_rentals_on_primary_driver_id", using: :btree
  add_index "rentals", ["vehicle_id"], name: "index_rentals_on_vehicle_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "address"
    t.string "password_digest"
  end

  create_table "vehicles", force: :cascade do |t|
    t.integer "year"
    t.string  "make"
    t.string  "model"
  end

  add_foreign_key "rentals", "vehicles"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
