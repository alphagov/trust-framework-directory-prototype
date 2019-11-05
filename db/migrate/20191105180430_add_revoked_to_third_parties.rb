class AddRevokedToThirdParties < ActiveRecord::Migration[6.0]
  def change
    add_column :third_parties, :revoked, :boolean, null: false, default: false
  end
end
