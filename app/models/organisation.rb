class Organisation < ApplicationRecord
  has_many :certificates
  has_many :ssas

  scope :brokers, -> { where(org_type: 'broker') }
  scope :idps, -> { where(org_type: 'idp') }

  def signing_cert
    certificates.where(usage: 'signing', purpose: 'organisation').first
  end

  def transport_cert
    certificates.where(usage: 'transport', purpose: 'organisation').first
  end

  def ssa_certificates(ssa_id)
    certificates.where(ssa_id: ssa_id, purpose: 'software')
  end

  def ssa_id
    ssas.first&.ssa_id
  end
end
