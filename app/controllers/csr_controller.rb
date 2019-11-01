class CsrController < ApplicationController
  def register
    third_party = ThirdParty.create(client_id: params[:client_id])
    pki = Pki.new
    cert = pki.csr_to_cert(params[:csr_pem])

    CsrPem.create(
      client_id: params[:client_id],
      value: params[:csr_pem],
      third_party_id: third_party.id,
      signed_certificate: pki.sign(cert).to_text
    )
    render json: { ok: 'go' }
  end

  def get_csr_public_key
    csr = CsrPem.where(client_id: params[:client_id]).first
    render plain: OpenSSL::X509::Request.new(csr.value).public_key.to_pem
  end

  def signed_certificate
    csr = CsrPem.where(client_id: params[:client_id]).first
    render plain: csr.signed_certificate
  end
end
