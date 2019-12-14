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

ActiveRecord::Schema.define(version: 2019_12_14_124903) do

  create_table "invites", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "from_uid", limit: 128, default: "", null: false
    t.string "to_address", limit: 128, default: "", null: false
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["from_uid"], name: "from_uid_idx"
    t.index ["to_address"], name: "to_address_idx"
  end

  create_table "locations", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "user_uid", limit: 128, default: "", null: false
    t.string "city", limit: 128, default: "", null: false
    t.string "country", limit: 128, default: "", null: false
    t.string "postal_code", limit: 16, default: "", null: false
    t.decimal "lat", precision: 8, scale: 5, default: "0.0", null: false
    t.decimal "lng", precision: 8, scale: 5, default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.integer "surfable", default: 0, null: false
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["city"], name: "city_idx"
    t.index ["country"], name: "country_idx"
    t.index ["lat", "lng"], name: "lat_lng_idx"
    t.index ["user_uid"], name: "uid_idx"
  end

  create_table "messages", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "from_uid", limit: 128, default: "", null: false
    t.string "to_uid", limit: 128, default: "", null: false
    t.text "body", null: false
    t.integer "is_read", default: 0, null: false
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["from_uid"], name: "from_uid_idx"
    t.index ["to_uid"], name: "to_uid_idx"
  end

  create_table "users", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "uid", limit: 128, default: "", null: false
    t.string "first_name", limit: 128, default: "John", null: false
    t.string "last_name", limit: 128, default: "Doe", null: false
    t.string "email", default: "", null: false
    t.string "password", default: "", null: false
    t.string "clear_password", default: "", null: false
    t.string "avatar", default: "", null: false
    t.integer "status", default: 0
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["email"], name: "email_idx"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "uid_index"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
