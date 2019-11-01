class AddSignedCertificateToCsrPems < ActiveRecord::Migration[6.0]
  def change
    add_column :csr_pems, :signed_certificate, :string
  end
end
