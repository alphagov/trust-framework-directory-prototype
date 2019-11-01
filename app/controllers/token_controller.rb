require 'time'

class TokenController < ApplicationController
  include JwtAud

  def make_token
    access_token = encode(jwt_claims)
    ThirdParty.where(client_id: params[:client_id]).first.tap do |third_party|
      third_party.access_token = access_token
      third_party.save!
    end
    render json: { "access_token": access_token }
  end

private

  def jwt_header
    {
      "kid": "999",
      "alg": "RS256"
    }
  end

  def jwt_claims
    {
      "iss": "did:gov:#{SecureRandom.uuid}",  # issuer
      "jti": SecureRandom.uuid,  # JWT ID
      "aud": "https://open-sesame.service.gov.uk",  # audience
      "nbf": Time.now.utc.to_i - 3600,  # not before
      "iat": Time.now.utc.to_i,  # issued at
      "exp": Time.now.utc.to_i + 4 * 3600,  # expiration
      "sub": SecureRandom.alphanumeric,  # subject
      "nonce": SecureRandom.uuid  # prevent tampering
    }
  end
end
