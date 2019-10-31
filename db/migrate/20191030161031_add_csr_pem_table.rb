class AddCsrPemTable < ActiveRecord::Migration[6.0]
  def change
    create_table "csr_pems" do |t|
      t.belongs_to :third_party
      t.string "client_id"
      t.string "value"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
