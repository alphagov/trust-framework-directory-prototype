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

ActiveRecord::Schema.define(version: 2019_11_05_180430) do

  create_table "csr_pems", force: :cascade do |t|
    t.integer "third_party_id"
    t.string "client_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "signed_certificate"
    t.index ["third_party_id"], name: "index_csr_pems_on_third_party_id"
  end

  create_table "keys", force: :cascade do |t|
    t.string "jwk_id"
    t.string "public_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "third_parties", force: :cascade do |t|
    t.string "client_id"
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "revoked", default: false, null: false
  end

end
