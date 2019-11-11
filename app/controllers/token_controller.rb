require 'time'

class TokenController < ApplicationController
  include JwtAud

  def make_token
    access_token = encode(jwt_claims, jwt_header)
    Organisation.find_by_organisation_id(params[:client_id]).tap do |org|
      org.access_token = access_token
      org.save!
    end
    render json: { "access_token": access_token }
  end

private

  def jwt_header
    {
      "typ": "JWT",
      "kid": OpenSSL::Digest::SHA1.new(rsa_public.to_der).to_s,
      "alg": "RS256"
    }
  end

  def jwt_claims
    {
      "iss": Rails.application.config.base_url,  # issuer
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
