# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_25_151447) do
  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "inns", force: :cascade do |t|
    t.string "corporate_name"
    t.string "brand_name"
    t.string "registration_number"
    t.string "phone"
    t.string "email"
    t.string "address"
    t.string "district"
    t.string "state"
    t.string "city"
    t.string "zip_code"
    t.string "description"
    t.string "payment_methods"
    t.boolean "accepts_pets"
    t.string "terms_of_service"
    t.time "check_in_check_out_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "user_id", null: false
    t.integer "status", default: 0
    t.index ["slug"], name: "index_inns_on_slug", unique: true
    t.index ["user_id"], name: "index_inns_on_user_id"
  end

  create_table "price_per_periods", force: :cascade do |t|
    t.integer "special_price"
    t.date "starts_at"
    t.date "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_id", null: false
    t.index ["room_id"], name: "index_price_per_periods_on_room_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "room_id", null: false
    t.datetime "check_in"
    t.datetime "check_out"
    t.integer "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "guests"
    t.string "slug"
    t.string "code"
    t.integer "status", default: 0
    t.string "payment_method"
    t.index ["room_id"], name: "index_reservations_on_room_id"
    t.index ["slug"], name: "index_reservations_on_slug", unique: true
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "text"
    t.integer "grade"
    t.integer "reservation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "answer"
    t.index ["reservation_id"], name: "index_reviews_on_reservation_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "area"
    t.integer "maximum_guests"
    t.integer "price"
    t.boolean "has_bathroom"
    t.boolean "has_balcony"
    t.boolean "has_air_conditioner"
    t.boolean "has_tv"
    t.boolean "has_wardrobe"
    t.boolean "has_coffer"
    t.boolean "accessible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "inn_id", null: false
    t.string "slug"
    t.integer "status", default: 0
    t.index ["inn_id"], name: "index_rooms_on_inn_id"
    t.index ["slug"], name: "index_rooms_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.string "name"
    t.string "registration_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "inns", "users"
  add_foreign_key "price_per_periods", "rooms"
  add_foreign_key "reservations", "rooms"
  add_foreign_key "reservations", "users"
  add_foreign_key "reviews", "reservations"
  add_foreign_key "reviews", "users"
  add_foreign_key "rooms", "inns"
end
