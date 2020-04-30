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

ActiveRecord::Schema.define(version: 2020_04_30_143558) do

  create_table "banks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.decimal "amt", precision: 10
    t.bigint "txn_status_id"
    t.bigint "txn_type_id"
    t.bigint "user_id"
    t.bigint "src_bank"
    t.bigint "dst_bank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dst_bank"], name: "fk_rails_33fa24c943"
    t.index ["src_bank"], name: "fk_rails_192879a8ec"
    t.index ["txn_status_id"], name: "fk_rails_46c7b3e8bf"
    t.index ["txn_type_id"], name: "fk_rails_e24322e737"
    t.index ["user_id"], name: "fk_rails_da4e89bd76"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.date "dob"
    t.string "mobile"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "txns", "banks", column: "dst_bank"
  add_foreign_key "txns", "banks", column: "src_bank"
  add_foreign_key "txns", "txn_statuses"
  add_foreign_key "txns", "txn_types"
  add_foreign_key "txns", "users"
end
