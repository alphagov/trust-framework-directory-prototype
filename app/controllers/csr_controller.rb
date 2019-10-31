class CsrController < ApplicationController

  def register
    third_party = ThirdParty.create(client_id: params[:client_id])
    CsrPem.create(
      client_id: params[:client_id],
      value: params[:csr_pem],
      third_party_id: third_party.id
    )
    render json: { ok: 'go' }
  end

  def get_csr_public_key
    csr = CsrPem.where(client_id: params[:client_id]).first
    render plain: OpenSSL::X509::Request.new(csr.value).public_key.to_pem
  end
end
