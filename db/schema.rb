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

ActiveRecord::Schema[7.0].define(version: 2023_07_24_073553) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "activity_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "activity_type"
    t.geography "location", limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.string "ip_address"
    t.string "device_info"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_activity_histories_on_user_id"
  end

  create_table "balances", force: :cascade do |t|
    t.bigint "therapist_id", null: false
    t.decimal "balance_amount", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["therapist_id"], name: "index_balances_on_therapist_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id"
    t.string "messages"
    t.boolean "is_send", default: false
    t.boolean "is_read", default: false
    t.integer "reference_id"
    t.string "reference_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tipe"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "therapist_id", null: false
    t.bigint "service_id", null: false
    t.string "order_status", default: "WAITING_CONFIRMATION", comment: "['WAITING_CONFIRMATION', 'WAITING_PAYMENT', 'PAID', 'DONE', 'CANCELED', 'EXPIRED']"
    t.datetime "appointment_date"
    t.integer "appointment_duration"
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.geography "location", limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid", null: false
    t.text "note"
    t.datetime "appointment_start_at"
    t.datetime "appointment_end"
    t.index ["service_id"], name: "index_orders_on_service_id"
    t.index ["therapist_id"], name: "index_orders_on_therapist_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "user_id", null: false
    t.string "payment_method", comment: "['OVO, 'DANA','RUPIAH_DIGITAL']"
    t.string "payment_status", default: "PENDING", comment: "['PENDING', 'SUCCESS', 'EXPIRED']"
    t.decimal "amount_paid", precision: 10, scale: 2, null: false
    t.string "to_account"
    t.string "sender_account"
    t.datetime "payment_expired"
    t.datetime "payment_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "therapist_id", null: false
    t.bigint "order_id", null: false
    t.bigint "rating"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_ratings_on_order_id"
    t.index ["therapist_id"], name: "index_ratings_on_therapist_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price_per_hour", precision: 10, scale: 2, null: false
    t.text "image"
    t.integer "minimum_duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "therapist_services", force: :cascade do |t|
    t.bigint "therapist_id", null: false
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_therapist_services_on_service_id"
    t.index ["therapist_id"], name: "index_therapist_services_on_therapist_id"
  end

  create_table "therapists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.geography "location", limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.integer "experience_years"
    t.text "photo"
    t.date "birthdate"
    t.string "gender", comment: "MALE, FEMALE, OTHER"
    t.boolean "is_available", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "day_start", default: 0, null: false
    t.integer "day_end", default: 0, null: false
    t.time "working_start"
    t.time "working_end"
    t.index ["user_id"], name: "index_therapists_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name_encrypted"
    t.string "last_name_encrypted"
    t.string "email"
    t.string "google_id"
    t.string "avatar"
    t.string "role", comment: "user, therapist, admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token_device"
  end

  add_foreign_key "activity_histories", "users"
  add_foreign_key "balances", "therapists"
  add_foreign_key "orders", "services"
  add_foreign_key "orders", "therapists"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "payments", "users"
  add_foreign_key "ratings", "orders"
  add_foreign_key "ratings", "therapists"
  add_foreign_key "ratings", "users"
  add_foreign_key "therapist_services", "services"
  add_foreign_key "therapist_services", "therapists"
  add_foreign_key "therapists", "users"
end
