class AddThirdpartyTable < ActiveRecord::Migration[6.0]
  def change
    create_table "third_parties" do |t|
      t.string "client_id"
      t.string "access_token"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
