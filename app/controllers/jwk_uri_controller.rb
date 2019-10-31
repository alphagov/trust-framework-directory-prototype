class JwkUriController < ApplicationController
  def get_key
    public_key = Key.where(jwk_id: params[:key_id]).first
    render plain: public_key
  end
end
