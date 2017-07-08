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

ActiveRecord::Schema.define(version: 20170708043837) do

  create_table "ambiences", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "device_modules", force: :cascade do |t|
    t.integer  "device_id",      limit: 4
    t.integer  "module_type_id", limit: 4
    t.boolean  "deleted",                  default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "device_modules", ["device_id"], name: "fk_rails_4ef150f78d", using: :btree
  add_index "device_modules", ["module_type_id"], name: "fk_rails_ddeaaf3b51", using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "model",              limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "ambience_id",        limit: 4
    t.integer  "scene_id",           limit: 4
    t.string   "network_identifier", limit: 255
  end

  add_index "devices", ["ambience_id"], name: "fk_rails_4e99b9066d", using: :btree
  add_index "devices", ["scene_id"], name: "fk_rails_f40fcfc251", using: :btree

  create_table "module_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

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

  create_table "sensor_log_data", id: false, force: :cascade do |t|
    t.integer "sensor_log_id", limit: 4
    t.integer "sensor_id",     limit: 4
    t.decimal "value",                   precision: 10
  end

  add_index "sensor_log_data", ["sensor_id"], name: "index_sensor_log_data_on_sensor_id", using: :btree
  add_index "sensor_log_data", ["sensor_log_id"], name: "index_sensor_log_data_on_sensor_log_id", using: :btree

  create_table "sensor_logs", force: :cascade do |t|
    t.datetime "date"
    t.integer  "device_module_id", limit: 4
  end

  add_index "sensor_logs", ["device_module_id"], name: "index_sensor_logs_on_device_module_id", using: :btree

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
    t.integer  "sensor_type_id",   limit: 4, null: false
    t.integer  "device_module_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "sensors", ["device_module_id"], name: "fk_rails_7be62d787f", using: :btree
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

  add_foreign_key "device_modules", "devices"
  add_foreign_key "device_modules", "module_types"
  add_foreign_key "devices", "ambiences"
  add_foreign_key "devices", "scenes"
  add_foreign_key "program_conditions", "programs"
  add_foreign_key "sensor_log_data", "sensor_logs"
  add_foreign_key "sensor_log_data", "sensors"
  add_foreign_key "sensor_logs", "device_modules"
  add_foreign_key "sensors", "device_modules"
  add_foreign_key "sensors", "sensor_types"
end
