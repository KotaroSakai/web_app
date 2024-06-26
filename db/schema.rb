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

ActiveRecord::Schema[7.0].define(version: 2024_04_05_090551) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_likes_on_post_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id"
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "send_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "send_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "send_type_id"
    t.index ["user_id"], name: "index_send_histories_on_user_id"
  end

  create_table "send_sets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.time "set_time", default: "2000-01-01 09:00:00"
    t.boolean "send_active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_send_sets_on_user_id"
  end

  create_table "send_types", force: :cascade do |t|
    t.string "send_class", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "smoke_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "smoked"
    t.date "smoke_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_smoke_records_on_user_id"
  end

  create_table "tobaccos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "price"
    t.integer "baseline_cigarette"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tobaccos_on_user_id"
  end

  create_table "user_partners", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "followed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "followed_id"], name: "index_user_partners_on_follower_id_and_followed_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "likes", "posts"
  add_foreign_key "likes", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "send_histories", "send_types"
  add_foreign_key "send_histories", "users"
  add_foreign_key "send_sets", "users"
  add_foreign_key "smoke_records", "users"
  add_foreign_key "tobaccos", "users"
end
