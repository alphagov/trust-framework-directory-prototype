require 'time'

class Ssa
  include JwtAud

  def initialize(name:, ssa_id:, base_url:)
    @name = name
    @ssa_id = ssa_id
    @base_url = base_url
  end

  def generate
    Key.create(jwk_id: jwk_id, public_key: rsa_public.to_s)
    encode(jwt_claims, jwt_header)
  end

private

  attr_reader :base_url, :name, :ssa_id

  def jwt_header
    {
      "typ": "JWT",
      "kid": SecureRandom.uuid,
      "alg": "RS256"
    }
  end

  def jwt_claims
    {
      "iss": "Trust Framework",
      "exp": Time.now.utc.to_i + 4 * 3600,
      "iat": Time.now.utc.to_i,
      "jti": SecureRandom.uuid,
      "org_id": SecureRandom.uuid,
      "org_contacts": [],
      "org_jwks_endpoint": jwk_uri,
      "org_jwks_revoked_endpoint": "#{base_url}/revoke",
      "org_name": name,
      "org_status": "Active",
      "software_client_id": ssa_id,
      "software_tos_uri": "http://trust-framework.gov.uk/terms.html",
      "software_client_description": name,
      "software_jwks_endpoint": "#{base_url}/jwk_uri",
      "software_mode": "TEST",
      "software_policy_uri": "http://trust-framework.gov.uk/policy.html",
      "software_id": SecureRandom.uuid,
      "software_jwks_revoked_endpoint": jwk_uri,
      "software_logo_uri": "#{base_url}/logo.jpg",
      "software_redirect_uris": [
        "#{base_url}/redirect"
      ],
      "software_roles": [
        "AISP",
        "PISP"
      ],
      "ob_registry_tos": "#{base_url}/tos",
    }
  end

  def jwk_uri
    @_jwk_uri ||= "#{base_url}/jwk_uri/#{jwk_id}"
  end

  def jwk_id
    @_jwk_id ||= SecureRandom.uuid
  end
end
