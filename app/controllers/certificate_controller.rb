class CertificateController < ApplicationController
  def generate
    organisation = Organisation.find_by_organisation_id(params[:client_id])

    generate_certs(organisation, 'organisation')
    generate_certs(organisation, 'software')

    render json: { "ok": "go" }
  end

private

  def generate_certs(organisation, purpose)
    pki = Pki.new

    signing_cert = pki.csr_to_cert(params[:signing_csr])
    Certificate.create(
      purpose: purpose,
      usage: 'signing',
      organisation_id: organisation.id,
      ssa_id: purpose == 'software' ? params[:ssa_id] : '',
      signed_certificate: pki.sign(signing_cert).to_pem,
      public_key: signing_cert.public_key.to_pem
    )

    transport_cert = pki.csr_to_cert(params[:transport_csr])
    Certificate.create(
      purpose: purpose,
      usage: 'transport',
      organisation_id: organisation.id,
      ssa_id: purpose == 'software' ? params[:ssa_id] : '',
      signed_certificate: pki.sign(transport_cert).to_pem,
      public_key: transport_cert.public_key.to_pem,
    )
  end
end
