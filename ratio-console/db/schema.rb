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

ActiveRecord::Schema.define(version: 20170927204055) do

  create_table "ambiences", force: :cascade do |t|
    t.string   "name",       limit: 255,                 null: false
    t.boolean  "is_deleted",             default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "device_definition_view", id: false, force: :cascade do |t|
    t.integer "device_id",      limit: 4, null: false
    t.integer "module_id",      limit: 4, null: false
    t.integer "sensor_type_id", limit: 4, null: false
  end

  create_table "device_event_sensors", id: false, force: :cascade do |t|
    t.integer "device_event_id", limit: 4,                         null: false
    t.integer "sensor_type_id",  limit: 4,                         null: false
    t.decimal "value",                     precision: 8, scale: 4, null: false
  end

  create_table "device_events", force: :cascade do |t|
    t.integer  "device_id", limit: 4,                 null: false
    t.integer  "module_id", limit: 4,                 null: false
    t.boolean  "state",               default: false, null: false
    t.datetime "ts",                                  null: false
  end

  create_table "device_events_view", id: false, force: :cascade do |t|
    t.integer  "id",              limit: 4,                         default: 0, null: false
    t.integer  "device_id",       limit: 4,                                     null: false
    t.integer  "module_id",       limit: 4,                                     null: false
    t.integer  "state",           limit: 4,                         default: 0, null: false
    t.datetime "ts",                                                            null: false
    t.integer  "device_event_id", limit: 4,                                     null: false
    t.integer  "sensor_type_id",  limit: 4,                                     null: false
    t.decimal  "value",                     precision: 8, scale: 4,             null: false
  end

  create_table "device_modules", force: :cascade do |t|
    t.integer  "device_id",      limit: 4
    t.integer  "module_type_id", limit: 4
    t.boolean  "disabled",                 default: false, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "device_modules", ["device_id"], name: "index_device_modules_on_device_id", using: :btree
  add_index "device_modules", ["module_type_id"], name: "index_device_modules_on_module_type_id", using: :btree

  create_table "device_states", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "devices", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.integer  "ambience_id",        limit: 4
    t.string   "network_identifier", limit: 255
    t.boolean  "deleted",                        default: false, null: false
    t.boolean  "disabled",                       default: false, null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "module_sensors", id: false, force: :cascade do |t|
    t.integer  "device_module_id", limit: 4
    t.integer  "sensor_type_id",   limit: 4
    t.boolean  "disabled"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "module_sensors", ["device_module_id"], name: "index_module_sensors_on_device_module_id", using: :btree
  add_index "module_sensors", ["sensor_type_id"], name: "index_module_sensors_on_sensor_type_id", using: :btree

  create_table "module_states", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "module_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "sensor_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "icon",       limit: 255
    t.string   "unit",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", primary_key: "login", force: :cascade do |t|
    t.string   "name",              limit: 255, null: false
    t.string   "mail",              limit: 255, null: false
    t.string   "crypted_password",  limit: 255, null: false
    t.string   "password_salt",     limit: 255, null: false
    t.string   "persistence_token", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_foreign_key "device_modules", "devices"
  add_foreign_key "device_modules", "module_types"
  add_foreign_key "module_sensors", "device_modules"
  add_foreign_key "module_sensors", "sensor_types"
end
