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

ActiveRecord::Schema.define(version: 2018_08_23_042749) do

  create_table "candidates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "users_id"
    t.bigint "elections_id"
    t.text "description"
    t.text "image", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["elections_id"], name: "index_candidates_on_elections_id"
    t.index ["users_id"], name: "index_candidates_on_users_id"
  end

  create_table "elections", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.text "description"
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.integer "number_of_voters", null: false
    t.text "image", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "idNumber", limit: 20, null: false
    t.string "email", limit: 50, null: false
    t.string "username", limit: 20, null: false
    t.text "password", null: false
    t.string "phone", limit: 20
    t.text "addressKey"
    t.text "publicKey"
    t.text "privateKey"
    t.text "signAddress"
    t.boolean "hasAttend", default: false
    t.boolean "hasVote", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "voters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "users_id"
    t.bigint "elections_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["elections_id"], name: "index_voters_on_elections_id"
    t.index ["users_id"], name: "index_voters_on_users_id"
  end

end
