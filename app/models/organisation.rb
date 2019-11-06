class Organisation < ApplicationRecord
  has_many :csr_pem
  has_many :ssa
end
