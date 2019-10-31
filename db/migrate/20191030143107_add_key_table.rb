class AddKeyTable < ActiveRecord::Migration[6.0]
  def change
    create_table "keys" do |t|
      t.string "jwk_id"
      t.string "public_key"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
