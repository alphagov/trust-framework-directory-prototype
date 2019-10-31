class CsrController < ApplicationController

  def register
    third_party = ThirdParty.create(client_id: params[:client_id])
    CsrPem.create(
      client_id: params[:client_id],
      value: params[:csr_pem],
      third_party_id: third_party.id
    )
  end

  render json: { ok: 'go' }
end
