class CsrPem < ApplicationRecord
  belongs_to :third_party, optional: true
end
