class AddOrganisationsTable < ActiveRecord::Migration[6.0]
  def change
    create_table "organisations" do |t|
      t.string "organisation_id"
      t.string "type"
      t.string "access_token"
      t.boolean "revoked", default: false, null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    change_table "csr_pems" do |t|
      t.remove_references :third_party
    end

    change_table "csr_pems" do |t|
      t.belongs_to :organisation
    end

    remove_column :csr_pems, :client_id

    drop_table :third_parties
  end
end
