class CreateCertificateTable < ActiveRecord::Migration[6.0]
  def change
    create_table :certificates do |t|
      t.belongs_to :organisation
      t.string "purpose"
      t.string "usage"
      t.string "ssa_id"
      t.string "signed_certificate"
      t.string "public_key"
      t.string "private_key"
      t.boolean "revoked", null: false, default: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    drop_table :csr_pems

    rename_column :organisations, :type, :org_type
  end
end
