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

ActiveRecord::Schema.define(version: 20171120003818) do

  create_table "ambiences", force: :cascade do |t|
    t.string   "name",       limit: 255,                 null: false
    t.boolean  "is_deleted",             default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "console_preferences", id: false, force: :cascade do |t|
    t.integer  "graphic_refresh_interval", limit: 4
    t.integer  "graphic_interval",         limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
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

  add_index "device_event_sensors", ["device_event_id"], name: "index_device_event_sensors_on_device_event_id", using: :btree
  add_index "device_event_sensors", ["sensor_type_id"], name: "index_device_event_sensors_on_sensor_type_id", using: :btree

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
    t.integer  "device_id",                  limit: 4
    t.integer  "module_type_id",             limit: 4
    t.boolean  "disabled",                               default: false, null: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "name",                       limit: 255
    t.boolean  "show_in_dashboard",                      default: false, null: false
    t.integer  "last_known_status",          limit: 4,   default: 0,     null: false
    t.datetime "last_known_status_datetime"
    t.integer  "previous_state",             limit: 4,   default: 0,     null: false
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
    t.boolean  "detection_pending",              default: false, null: false
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

  create_table "schedule_days", force: :cascade do |t|
    t.integer  "schedule_id", limit: 4
    t.integer  "day",         limit: 4
    t.string   "start_hour",  limit: 7, null: false
    t.string   "end_hour",    limit: 7, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "schedule_days", ["schedule_id"], name: "index_schedule_days_on_schedule_id", using: :btree

  create_table "schedule_modules", force: :cascade do |t|
    t.integer  "device_module_id", limit: 4
    t.integer  "desired_status",   limit: 4, null: false
    t.integer  "schedule_id",      limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "schedule_modules", ["device_module_id", "schedule_id"], name: "index_schedule_modules_on_device_module_id_and_schedule_id", unique: true, using: :btree
  add_index "schedule_modules", ["device_module_id"], name: "index_schedule_modules_on_device_module_id", using: :btree
  add_index "schedule_modules", ["schedule_id"], name: "index_schedule_modules_on_schedule_id", using: :btree

  create_table "schedules", force: :cascade do |t|
    t.string   "description", limit: 255
    t.boolean  "inactive"
    t.boolean  "enabled"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "is_running",              default: false, null: false
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
  add_foreign_key "schedule_days", "schedules"
  add_foreign_key "schedule_modules", "device_modules"
  add_foreign_key "schedule_modules", "schedules"
end
