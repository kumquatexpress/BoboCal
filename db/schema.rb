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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120730193608) do

  create_table "calendar_events", :force => true do |t|
    t.integer  "calendar_id"
    t.integer  "event_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "calendars", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "event_ids"
  end

  create_table "calendars_events", :id => false, :force => true do |t|
    t.integer "calendar_id"
    t.integer "event_id"
  end

  create_table "calendars_users", :id => false, :force => true do |t|
    t.integer "calendar_id"
    t.integer "user_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "events", :force => true do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "title",        :default => "My New Event"
    t.integer  "calendar_ids"
    t.integer  "post_ids"
    t.integer  "user_id"
    t.integer  "invited_ids"
    t.string   "google_id"
    t.string   "location"
  end

  create_table "events_posts", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "event_id"
  end

  create_table "events_timeperiods", :id => false, :force => true do |t|
    t.integer "timeperiod_id"
    t.integer "event_id"
  end

  create_table "events_users", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "user_id"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.boolean  "approved"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "ignored"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "userid"
    t.integer  "event_ids"
  end

  create_table "posts_users", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "user_id"
  end

  create_table "timeperiods", :force => true do |t|
    t.datetime "time"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                :default => "",    :null => false
    t.string   "encrypted_password",                   :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.integer  "calendar_id"
    t.integer  "event_id"
    t.integer  "post_id"
    t.string   "image_url"
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "fb_token"
    t.boolean  "fbonly"
    t.boolean  "admin",                                :default => false
    t.string   "refresh_token"
    t.string   "token"
    t.string   "google_id",              :limit => 64
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
