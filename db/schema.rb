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

ActiveRecord::Schema[7.0].define(version: 2023_01_04_160427) do
  create_table "groups", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "id_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keywords", charset: "utf8mb4", force: :cascade do |t|
    t.string "option", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "question"
  end

  create_table "likes", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "like_user_id"
    t.bigint "liked_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["like_user_id", "liked_user_id"], name: "index_likes_on_like_user_id_and_liked_user_id", unique: true
    t.index ["like_user_id"], name: "index_likes_on_like_user_id"
    t.index ["liked_user_id"], name: "index_likes_on_liked_user_id"
  end

  create_table "member_ships", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_member_ships_on_group_id"
    t.index ["user_id", "group_id"], name: "index_member_ships_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_member_ships_on_user_id"
  end

  create_table "user_keywords", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "keyword_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_user_keywords_on_keyword_id"
    t.index ["user_id", "keyword_id"], name: "index_user_keywords_on_user_id_and_keyword_id", unique: true
    t.index ["user_id"], name: "index_user_keywords_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "disabled", default: false
  end

  create_table "votes", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "voter_id"
    t.bigint "voted_id"
    t.bigint "keyword_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_votes_on_keyword_id"
    t.index ["voted_id"], name: "index_votes_on_voted_id"
    t.index ["voter_id", "keyword_id", "voted_id"], name: "index_votes_on_voter_id_and_keyword_id_and_voted_id", unique: true
    t.index ["voter_id"], name: "index_votes_on_voter_id"
  end

  add_foreign_key "likes", "users", column: "like_user_id"
  add_foreign_key "likes", "users", column: "liked_user_id"
  add_foreign_key "member_ships", "groups"
  add_foreign_key "member_ships", "users"
  add_foreign_key "user_keywords", "users"
  add_foreign_key "votes", "keywords"
  add_foreign_key "votes", "users", column: "voted_id"
  add_foreign_key "votes", "users", column: "voter_id"
end
