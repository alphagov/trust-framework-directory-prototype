class JwkUriController < ApplicationController
  def get_org_public_key
    csr = CsrPem.where(client_id: params[:name]).first
    render plain: OpenSSL::X509::Request.new(csr.value).public_key.to_pem
  end

  def get_software_public_key
    public_key = Key.where(jwk_id: params[:ssa_id]).first.public_key
    render plain: public_key
  end
end
