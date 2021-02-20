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

ActiveRecord::Schema.define(version: 2021_02_20_224200) do

  create_table "cards", force: :cascade do |t|
    t.integer "number"
    t.integer "suit_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["suit_id"], name: "index_cards_on_suit_id"
  end

  create_table "cards_hands", id: false, force: :cascade do |t|
    t.integer "card_id", null: false
    t.integer "hand_id", null: false
  end

  create_table "hands", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "moves", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "initial_hand_id"
    t.integer "deck_hand_id"
    t.integer "best_hand_id"
    t.index ["best_hand_id"], name: "index_moves_on_best_hand_id"
    t.index ["deck_hand_id"], name: "index_moves_on_deck_hand_id"
    t.index ["initial_hand_id"], name: "index_moves_on_initial_hand_id"
  end

  create_table "moves_old", force: :cascade do |t|
    t.string "hand_cards"
    t.string "deck_cards"
    t.string "best_move_cards"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "suits", force: :cascade do |t|
    t.string "name"
    t.string "letter"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "cards", "suits"
end
