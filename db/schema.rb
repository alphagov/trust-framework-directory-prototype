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

ActiveRecord::Schema.define(version: 2019_11_11_155814) do

  create_table "certificates", force: :cascade do |t|
    t.integer "organisation_id"
    t.string "purpose"
    t.string "usage"
    t.string "ssa_id"
    t.string "signed_certificate"
    t.string "public_key"
    t.string "private_key"
    t.boolean "revoked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_certificates_on_organisation_id"
  end

  create_table "keys", force: :cascade do |t|
    t.string "jwk_id"
    t.string "public_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organisations", force: :cascade do |t|
    t.string "organisation_id"
    t.string "org_type"
    t.string "access_token"
    t.boolean "revoked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "loa"
    t.string "name"
    t.string "domain"
  end

  create_table "ssas", force: :cascade do |t|
    t.integer "organisation_id"
    t.string "ssa_id"
    t.string "statement"
    t.boolean "revoked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_ssas_on_organisation_id"
  end

end
