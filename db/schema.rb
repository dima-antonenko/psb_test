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

ActiveRecord::Schema[7.1].define(version: 2024_08_03_072002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "user_id"
    t.integer "expertise_ids", default: [], null: false, array: true
    t.integer "liked_user_ids", default: [], null: false, array: true
    t.integer "disliked_user_ids", default: [], null: false, array: true
    t.integer "total_views", default: 1, null: false
    t.integer "reviews_count", default: 0, null: false
    t.integer "appeals_count", default: 0, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted"], name: "index_courses_on_deleted"
    t.index ["description"], name: "index_courses_on_description"
    t.index ["disliked_user_ids"], name: "index_courses_on_disliked_user_ids"
    t.index ["expertise_ids"], name: "index_courses_on_expertise_ids"
    t.index ["liked_user_ids"], name: "index_courses_on_liked_user_ids"
    t.index ["title"], name: "index_courses_on_title"
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "expertises", force: :cascade do |t|
    t.string "title"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_expertises_on_title"
  end

  create_table "network_logs", force: :cascade do |t|
    t.integer "user_id"
    t.string "event_type", null: false
    t.string "logable_type"
    t.integer "logable_id"
    t.string "ip"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type"], name: "index_network_logs_on_event_type"
    t.index ["ip"], name: "index_network_logs_on_ip"
    t.index ["logable_id"], name: "index_network_logs_on_logable_id"
    t.index ["logable_type"], name: "index_network_logs_on_logable_type"
    t.index ["user_agent"], name: "index_network_logs_on_user_agent"
    t.index ["user_id"], name: "index_network_logs_on_user_id"
  end

  create_table "support_requests", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "email"
    t.text "message"
    t.boolean "viewed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_support_requests_on_email"
    t.index ["name"], name: "index_support_requests_on_name"
    t.index ["user_id"], name: "index_support_requests_on_user_id"
    t.index ["viewed"], name: "index_support_requests_on_viewed"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "surname"
    t.string "language", default: "ru", null: false
    t.integer "rating", default: 0, null: false
    t.integer "appeals_count", default: 0, null: false
    t.boolean "full_access", default: false, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "authentication_token"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted"], name: "index_users_on_deleted"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["full_access"], name: "index_users_on_full_access"
    t.index ["language"], name: "index_users_on_language"
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["surname"], name: "index_users_on_surname"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
