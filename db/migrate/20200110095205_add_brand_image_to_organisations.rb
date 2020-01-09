class AddBrandImageToOrganisations < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :brand_image, :string
  end
end
