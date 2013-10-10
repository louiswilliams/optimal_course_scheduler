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

ActiveRecord::Schema.define(version: 20131010024237) do

  create_table "courses", force: true do |t|
    t.string   "name"
    t.string   "college"
    t.decimal  "credits"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meetings", force: true do |t|
    t.integer  "section_id"
    t.string   "location"
    t.time     "start_time"
    t.time     "end_time"
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
  end

  add_index "meetings", ["course_id"], name: "index_meetings_on_course_id"
  add_index "meetings", ["section_id"], name: "index_meetings_on_section_id"

  create_table "schedule_courses", force: true do |t|
    t.integer  "schedule_id"
    t.integer  "course_id"
    t.integer  "section_id"
    t.boolean  "scheduled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedule_courses", ["course_id"], name: "index_schedule_courses_on_course_id"
  add_index "schedule_courses", ["schedule_id"], name: "index_schedule_courses_on_schedule_id"
  add_index "schedule_courses", ["section_id"], name: "index_schedule_courses_on_section_id"

  create_table "schedules", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "year"
    t.integer  "semester"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id"

  create_table "sections", force: true do |t|
    t.string   "name"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sections", ["course_id"], name: "index_sections_on_course_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
