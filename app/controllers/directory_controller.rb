class DirectoryController < ApplicationController
  def root_ca
    render plain: Certificate.where(purpose: 'root').first.signed_certificate
  end

  def ssa_signing_public_key
    render plain: Key.find_by_jwk_id(params[:ssa_id]).public_key
  end
end
