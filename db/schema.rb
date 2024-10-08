# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160331151022) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "matches", force: :cascade do |t|
    t.integer  "home_player_id"
    t.integer  "home_player_score"
    t.integer  "visitor_player_id"
    t.integer  "visitor_player_score"
    t.integer  "winner_id"
    t.datetime "occurred_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "matches", ["home_player_id"], name: "index_matches_on_home_player_id", using: :btree
  add_index "matches", ["visitor_player_id"], name: "index_matches_on_visitor_player_id", using: :btree
  add_index "matches", ["winner_id"], name: "index_matches_on_winner_id", using: :btree

  create_table "players", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "team_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "players", ["email"], name: "index_players_on_email", unique: true, using: :btree

  create_table "rankings", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "matches_count"
    t.integer  "matches_won"
    t.integer  "matches_lost"
    t.integer  "matches_draw"
    t.integer  "goals_pro"
    t.integer  "goals_against"
    t.integer  "goals_balance"
    t.integer  "total_points"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "year"
  end

  add_index "rankings", ["player_id"], name: "index_rankings_on_player_id", using: :btree

end
