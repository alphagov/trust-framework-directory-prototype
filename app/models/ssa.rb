require 'time'

class Ssa
  include JwtAud

  def initialize(name:, ssa_id:)
    @name = name
    @ssa_id = ssa_id
  end

  def generate
    Key.create(jwk_id: jwk_id, public_key: rsa_public.to_s)
    encode(jwt_claims)
  end

private

  attr_reader :name, :ssa_id

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
      "org_jwks_revoked_endpoint": "https://localhost:3000/revoke",
      "org_name": name,
      "org_status": "Active",
      "software_client_id": ssa_id,
      "software_tos_uri": "http://trust-framework.gov.uk/terms.html",
      "software_client_description": name,
      "software_jwks_endpoint": "https://localhost:3000/jwk_uri",
      "software_mode": "TEST",
      "software_policy_uri": "http://trust-framework.gov.uk/policy.html",
      "software_id": SecureRandom.uuid,
      "software_jwks_revoked_endpoint": jwk_uri,
      "software_logo_uri": "http://localhost:3000/logo.jpg",
      "software_redirect_uris": [
        "http://localhost:3000/redirect"
      ],
      "software_roles": [
        "AISP",
        "PISP"
      ],
      "ob_registry_tos": "https://localhost:3000/tos/",
    }
  end

  def jwk_uri
    @_jwk_uri ||= "https://localhost:3000/jwk_uri/#{jwk_id}"
  end

  def jwk_id
    @_jwk_id ||= SecureRandom.uuid
  end
end
