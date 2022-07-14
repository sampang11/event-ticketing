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

ActiveRecord::Schema.define(version: 2022_07_13_025807) do

  create_table "attendances", force: :cascade do |t|
    t.integer "ticket_id", null: false
    t.integer "status", default: 0
    t.datetime "entry_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ticket_id"], name: "index_attendances_on_ticket_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "games", force: :cascade do |t|
    t.integer "team_one_id"
    t.integer "team_two_id"
    t.integer "team_one_score"
    t.integer "team_two_score"
    t.integer "game_week"
    t.integer "game_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "competition_id", null: false
    t.index ["competition_id"], name: "index_games_on_competition_id"
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

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "image_data"
    t.integer "team_id", null: false
    t.string "position"
    t.integer "player_role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "qr_codes", force: :cascade do |t|
    t.string "data"
  end

  create_table "team_competitions", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "competition_id", null: false
    t.integer "points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["competition_id"], name: "index_team_competitions_on_competition_id"
    t.index ["team_id"], name: "index_team_competitions_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "logo_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.string "ticket_number"
    t.integer "participant_id", null: false
    t.integer "age_group", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["participant_id"], name: "index_tickets_on_participant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "week_tables", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "points"
    t.integer "goal_for"
    t.integer "goal_against"
    t.integer "match_played"
    t.integer "goal_diff"
    t.integer "result"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_week_tables_on_team_id"
  end

  add_foreign_key "attendances", "tickets"
  add_foreign_key "games", "competitions"
  add_foreign_key "players", "teams"
  add_foreign_key "team_competitions", "competitions"
  add_foreign_key "team_competitions", "teams"
  add_foreign_key "tickets", "participants"
  add_foreign_key "week_tables", "teams"
end
