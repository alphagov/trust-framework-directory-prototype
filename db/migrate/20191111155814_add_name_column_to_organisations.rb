class AddNameColumnToOrganisations < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :name, :string
    add_column :organisations, :domain, :string
  end
end
