class AddLoaColumnToOrganisations < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :loa, :string
  end
end
