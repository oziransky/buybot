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

ActiveRecord::Schema.define(:version => 20111223083245) do

  create_table "auction_histories", :force => true do |t|
    t.string   "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "bids"
    t.integer  "closed_reason"
  end

  create_table "auction_statuses", :force => true do |t|
    t.integer  "auction_id"
    t.integer  "store_id"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auction_statuses", ["auction_id"], :name => "index_auction_statuses_on_auction_id"
  add_index "auction_statuses", ["store_id"], :name => "index_auction_statuses_on_store_id"

  create_table "auctions", :force => true do |t|
    t.integer  "product_id"
    t.float    "minimal_step"
    t.float    "maximum_step"
    t.integer  "max_num_bids"
    t.float    "current_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "status"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "parent_id"
  end

  create_table "categories_products", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "product_id"
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "prices", :force => true do |t|
    t.integer  "product_id"
    t.integer  "store_id"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["product_id"], :name => "index_prices_on_product_id"
  add_index "prices", ["store_id"], :name => "index_prices_on_store_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.integer  "catalog_id"
    t.string   "image_folder"
    t.string   "manufacturer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products_stores", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "store_id"
  end

  create_table "store_owners", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "store_owners", ["email"], :name => "index_store_owners_on_email", :unique => true
  add_index "store_owners", ["reset_password_token"], :name => "index_store_owners_on_reset_password_token", :unique => true

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "url"
    t.string   "description"
    t.integer  "store_owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
