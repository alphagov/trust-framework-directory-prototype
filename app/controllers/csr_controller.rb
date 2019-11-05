class CsrController < ApplicationController
  def register
    organisation = Organisation.create(organisation_id: params[:client_id])
    pki = Pki.new
    cert = pki.csr_to_cert(params[:csr_pem])

    CsrPem.create(
      organisation_id: organisation.id,
      value: params[:csr_pem],
      signed_certificate: pki.sign(cert).to_text
    )
    render json: { "ok": "go" }
  end

  def mtls_and_signing_certificate
    csr = Organisation.find_by_organisation_id(params[:client_id]).csr_pem.first
    render json: { "certificate": csr.signed_certificate }
  end
end
