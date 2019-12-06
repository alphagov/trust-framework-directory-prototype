class AddSchemeToOrganisation < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :scheme, :string
  end
end
