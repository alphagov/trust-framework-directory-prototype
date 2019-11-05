require 'time'

class TokenController < ApplicationController
  include JwtAud

  def make_token
    access_token = encode(jwt_claims, jwt_header)
    ThirdParty.where(client_id: params[:client_id]).first.tap do |third_party|
      third_party.access_token = access_token
      third_party.save!
    end
    render json: { "access_token": access_token }
  end

private

  def jwt_header
    {
      "typ": "JWT",
      "kid": SecureRandom.uuid,
      "alg": "RS256"
    }
  end

  def jwt_claims
    {
      "iss": request.base_url,  # issuer
      "jti": SecureRandom.uuid,  # JWT ID
      "aud": params[:client_id],  # audience
      "nbf": Time.now.utc.to_i - 3600,  # not before
      "iat": Time.now.utc.to_i,  # issued at
      "exp": Time.now.utc.to_i + 4 * 3600,  # expiration
      "sub": SecureRandom.alphanumeric,  # subject
      "nonce": SecureRandom.uuid  # prevent tampering
    }
  end
end
