class Certificate < ApplicationRecord
  belongs_to :organisation, optional: true
end
