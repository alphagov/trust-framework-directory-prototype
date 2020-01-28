class AddClientTokenToOrganisations < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :client_token, :string
  end
end
