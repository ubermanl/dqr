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

ActiveRecord::Schema.define(version: 20170607184945) do

  create_table "ambiences", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "device_sensors", force: :cascade do |t|
    t.integer  "device_id",      limit: 4, null: false
    t.integer  "sensor_type_id", limit: 4, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "device_sensors", ["device_id"], name: "fk_rails_66435e2693", using: :btree
  add_index "device_sensors", ["sensor_type_id"], name: "fk_rails_75cb1de861", using: :btree

  create_table "device_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "description", limit: 255
    t.boolean  "inactive"
  end

  create_table "devices", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.integer  "device_type_id",     limit: 4,   null: false
    t.string   "model",              limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "ambience_id",        limit: 4
    t.integer  "scene_id",           limit: 4
    t.string   "network_identifier", limit: 255
  end

  add_index "devices", ["ambience_id"], name: "fk_rails_4e99b9066d", using: :btree
  add_index "devices", ["device_type_id"], name: "index_devices_on_device_type_id", using: :btree
  add_index "devices", ["scene_id"], name: "fk_rails_f40fcfc251", using: :btree

  create_table "program_conditions", force: :cascade do |t|
    t.integer  "program_id",       limit: 4,                          null: false
    t.integer  "device_sensor_id", limit: 4,                          null: false
    t.decimal  "min_value",                  precision: 10, scale: 4
    t.decimal  "max_value",                  precision: 10, scale: 4
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "program_conditions", ["device_sensor_id"], name: "index_program_conditions_on_device_sensor_id", using: :btree
  add_index "program_conditions", ["program_id"], name: "index_program_conditions_on_program_id", using: :btree

  create_table "programs", force: :cascade do |t|
    t.integer  "object_id",     limit: 4
    t.string   "object_type",   limit: 255
    t.integer  "priority",      limit: 4,   null: false
    t.boolean  "desired_state"
    t.string   "description",   limit: 255
    t.string   "start_time",    limit: 255
    t.string   "stop_time",     limit: 255
    t.boolean  "inactive"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "programs", ["object_type", "object_id"], name: "index_programs_on_object_type_and_object_id", using: :btree

  create_table "scenes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "inactive"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "sensor_events", force: :cascade do |t|
    t.integer  "device_sensor_id", limit: 4,                          null: false
    t.decimal  "value",                      precision: 10, scale: 4
    t.datetime "created_at"
  end

  add_index "sensor_events", ["device_sensor_id"], name: "index_sensor_events_on_device_sensor_id", using: :btree

  create_table "sensor_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "unit",       limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.decimal  "max_value",              precision: 10, scale: 4
    t.decimal  "min_value",              precision: 10, scale: 4
    t.boolean  "inactive"
  end

  create_table "sensors", force: :cascade do |t|
    t.integer  "sensor_type_id", limit: 4, null: false
    t.integer  "device_id",      limit: 4, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "sensors", ["device_id"], name: "fk_rails_92e56bf2fb", using: :btree
  add_index "sensors", ["sensor_type_id"], name: "fk_rails_c25b245ee7", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "crypted_password",  limit: 255, null: false
    t.string   "password_salt",     limit: 255, null: false
    t.string   "persistence_token", limit: 255
    t.string   "login",             limit: 255, null: false
  end

  add_foreign_key "device_sensors", "devices"
  add_foreign_key "device_sensors", "sensor_types"
  add_foreign_key "devices", "ambiences"
  add_foreign_key "devices", "device_types"
  add_foreign_key "devices", "scenes"
  add_foreign_key "program_conditions", "device_sensors"
  add_foreign_key "program_conditions", "programs"
  add_foreign_key "sensor_events", "device_sensors"
  add_foreign_key "sensors", "devices"
  add_foreign_key "sensors", "sensor_types"
end
