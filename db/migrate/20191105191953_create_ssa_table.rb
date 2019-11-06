class CreateSsaTable < ActiveRecord::Migration[6.0]
  def change
    create_table :ssas do |t|
      t.belongs_to :organisation
      t.string "ssa_id"
      t.string "statement"
      t.boolean "revoked", default: false, null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
