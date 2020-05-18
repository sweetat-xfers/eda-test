# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_17_131657) do

  create_table "banks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.decimal "amt", precision: 20, scale: 5
    t.string "aasm_state", limit: 191
    t.bigint "type_id", null: false
    t.bigint "user_id", null: false
    t.bigint "src_bank_id", null: false
    t.bigint "dst_bank_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dst_bank_id"], name: "index_transactions_on_dst_bank_id"
    t.index ["src_bank_id"], name: "index_transactions_on_src_bank_id"
    t.index ["type_id"], name: "index_transactions_on_type_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "txn_statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "txn_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "txns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.decimal "amt", precision: 20, scale: 5
    t.bigint "txn_status_id", null: false
    t.bigint "txn_type_id", null: false
    t.bigint "user_id", null: false
    t.bigint "src_bank_id", null: false
    t.bigint "dst_bank_id", null: false
    t.string "aasm_state", limit: 191
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dst_bank_id"], name: "index_txns_on_dst_bank_id"
    t.index ["src_bank_id"], name: "index_txns_on_src_bank_id"
    t.index ["txn_status_id"], name: "index_txns_on_txn_status_id"
    t.index ["txn_type_id"], name: "index_txns_on_txn_type_id"
    t.index ["user_id"], name: "index_txns_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.date "dob"
    t.string "mobile"
    t.string "email"
    t.decimal "balance", precision: 20, scale: 5
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "transactions", "banks", column: "dst_bank_id"
  add_foreign_key "transactions", "banks", column: "src_bank_id"
  add_foreign_key "transactions", "users"
  add_foreign_key "txns", "banks", column: "dst_bank_id"
  add_foreign_key "txns", "banks", column: "src_bank_id"
  add_foreign_key "txns", "txn_statuses"
  add_foreign_key "txns", "txn_types"
  add_foreign_key "txns", "users"
end
