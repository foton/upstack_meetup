# frozen_string_literal: true

class UpstackSchemaUpload < ActiveRecord::Migration[5.2]
  # structure dump from existing database
  def change
    create_table "invites", id: :integer, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
      t.string "from_uid", limit: 128, default: "", null: false
      t.string "to_address", limit: 128, default: "", null: false
      t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }
      t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }
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
      t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }
      t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }
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
      t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }
      t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }
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
      t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }
      t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }
      t.index ["email"], name: "email_idx"
      t.index ["uid"], name: "uid_index", unique: true
    end
  end
end
