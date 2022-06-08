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

ActiveRecord::Schema.define(version: 2022_06_06_011926) do

  create_table "attendances", force: :cascade do |t|
    t.integer "ticket_id", null: false
    t.integer "status", default: 0
    t.datetime "entry_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ticket_id"], name: "index_attendances_on_ticket_id"
  end

  create_table "participants", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "phone_no"
    t.string "e_transfer_number"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address"
  end

  create_table "qr_codes", force: :cascade do |t|
    t.string "data"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "ticket_number"
    t.integer "participant_id", null: false
    t.integer "age_group", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["participant_id"], name: "index_tickets_on_participant_id"
  end

  add_foreign_key "attendances", "tickets"
  add_foreign_key "tickets", "participants"
end
