# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080720201033) do

  create_table "logged_exceptions", :force => true do |t|
    t.string   "exception_class"
    t.string   "controller_name"
    t.string   "action_name"
    t.text     "message"
    t.text     "backtrace"
    t.text     "environment"
    t.text     "request"
    t.datetime "created_at"
  end

  create_table "quotes", :force => true do |t|
    t.text     "quote"
    t.text     "author"
    t.text     "quoted_by"
    t.text     "quote_context"
    t.text     "author_title"
    t.text     "copyright"
    t.date     "quoted_at"
    t.integer  "user_id",       :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",        :limit => 11
    t.integer  "taggable_id",   :limit => 11
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
    t.integer  "tagger_id",     :limit => 11
    t.string   "tagger_type"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                   :default => "passive"
    t.datetime "deleted_at"
    t.string   "first_name",                              :default => "",        :null => false
    t.string   "last_name",                               :default => "",        :null => false
  end

  create_table "votes", :force => true do |t|
    t.boolean  "vote",                        :default => false
    t.string   "voteable_type", :limit => 15, :default => "",    :null => false
    t.integer  "voteable_id",   :limit => 11, :default => 0,     :null => false
    t.integer  "voter_id",      :limit => 11, :default => 0,     :null => false
    t.string   "voter_type",    :limit => 15, :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type", "voter_id", "voter_type"], :name => "uniq_voter_voteable", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "fk_voters"
  add_index "votes", ["voteable_id", "voteable_type"], :name => "fk_voteables"

end
