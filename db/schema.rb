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

ActiveRecord::Schema.define(version: 2021_04_26_011523) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brackets", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "tournament_group_id"
    t.json "match_data"
    t.index ["tournament_group_id"], name: "index_brackets_on_tournament_group_id"
    t.index ["user_id", "tournament_group_id"], name: "index_brackets_on_user_id_and_tournament_group_id", unique: true
    t.index ["user_id"], name: "index_brackets_on_user_id"
  end

  create_table "courts", force: :cascade do |t|
    t.string "name"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_courts_on_location_id"
  end

  create_table "courts_tournament_rounds", id: false, force: :cascade do |t|
    t.bigint "tournament_round_id", null: false
    t.bigint "court_id", null: false
  end

  create_table "divisions", force: :cascade do |t|
    t.string "name"
    t.integer "day_of_week"
    t.string "time"
    t.bigint "season_id"
    t.text "final_standings"
    t.integer "league_apps_site_id"
    t.integer "league_apps_program_id"
    t.index ["season_id"], name: "index_divisions_on_season_id"
  end

  create_table "divisions_teams", id: false, force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "division_id", null: false
    t.index ["division_id", "team_id"], name: "index_divisions_teams_on_division_id_and_team_id"
    t.index ["team_id", "division_id"], name: "index_divisions_teams_on_team_id_and_division_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "match_id"
    t.integer "number"
    t.bigint "yellow_team_id"
    t.bigint "black_team_id"
    t.json "frames"
    t.integer "game_type", default: 0, null: false
    t.integer "max_frames", default: 8
    t.integer "max_points"
    t.boolean "allow_ties", default: false, null: false
    t.integer "change_colors_after_frames"
    t.integer "change_colors_every_frames"
    t.index ["black_team_id"], name: "index_games_on_black_team_id"
    t.index ["match_id"], name: "index_games_on_match_id"
    t.index ["yellow_team_id"], name: "index_games_on_yellow_team_id"
  end

  create_table "live_events", force: :cascade do |t|
    t.boolean "show_bracket", default: false
    t.bigint "left_game_id"
    t.bigint "right_game_id"
    t.index ["left_game_id"], name: "index_live_events_on_left_game_id"
    t.index ["right_game_id"], name: "index_live_events_on_right_game_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "address_line1"
    t.string "address_line2"
    t.string "address_city"
    t.string "address_state"
    t.string "address_zip"
    t.string "address_country"
    t.string "timezone"
    t.string "uri"
  end

  create_table "matches", force: :cascade do |t|
    t.string "location"
    t.datetime "time"
    t.integer "home_score"
    t.integer "away_score"
    t.boolean "counts_toward_elo", default: true
    t.bigint "home_team_id"
    t.bigint "away_team_id"
    t.bigint "division_id"
    t.string "comment"
    t.integer "home_old_elo"
    t.integer "home_new_elo"
    t.integer "away_old_elo"
    t.integer "away_new_elo"
    t.bigint "court_id"
    t.float "multiplier", default: 1.0, null: false
    t.bigint "tournament_round_id"
    t.integer "tournament_order"
    t.integer "league_apps_game_id"
    t.index ["court_id"], name: "index_matches_on_court_id"
    t.index ["division_id"], name: "index_matches_on_division_id"
    t.index ["tournament_round_id"], name: "index_matches_on_tournament_round_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "playoff_date"
    t.date "banquet_date"
    t.integer "champion_id"
    t.text "report"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_seasons_on_location_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "former_names"
    t.integer "elo_cache"
    t.string "captain"
    t.integer "starting_elo"
    t.integer "previous_elo"
    t.string "short_name"
    t.integer "starting_match_count"
    t.string "image_uri"
    t.string "instagram_user"
    t.integer "starting_wins", default: 0
    t.integer "starting_losses", default: 0
    t.string "country"
    t.bigint "location_id"
    t.string "param_name"
    t.index ["location_id"], name: "index_teams_on_location_id"
  end

  create_table "tournament_groups", force: :cascade do |t|
    t.string "name"
    t.bigint "tournament_id"
    t.datetime "bracket_start_time"
    t.datetime "bracket_end_time"
    t.index ["tournament_id"], name: "index_tournament_groups_on_tournament_id"
  end

  create_table "tournament_rounds", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.bigint "tournament_group_id"
    t.string "format"
    t.integer "rotation"
    t.index ["tournament_group_id"], name: "index_tournament_rounds_on_tournament_group_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "uri"
    t.string "format"
    t.string "description"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_tournaments_on_location_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "provider"
    t.string "uid"
    t.string "first_name"
    t.string "last_name"
    t.boolean "is_admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "divisions", "seasons"
end
