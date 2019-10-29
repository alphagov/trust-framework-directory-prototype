require 'time'

class Ssa
  include JwtAud

  def initialize(name:, ssa_id:)
    @name = name
    @ssa_id = ssa_id
  end

  def generate
    payload = "#{Base64.encode64(jwt_header.to_s.strip)}.#{Base64.encode64(jwt_claims.to_s.strip)}"
    signature = encode(payload.encode("ASCII"))
    "#{payload}.#{signature}"
  end

private

  attr_reader :name, :ssa_id

  def jwt_header
    {
      "kid": SecureRandom.uuid,
      "alg": "RS256"
    }
  end

  def jwt_claims
    {
      "org_jwks_endpoint": "https://directory.cloudapps.digital/jwks",
      "software_mode": "TEST",
      "software_redirect_uris": [
        "http://example.com/redirect"
      ],
      "org_status": "Active",
      "software_client_id": ssa_id,
      "iss": "Trust Framework",
      "software_tos_uri": "http://trust-framework.gov.uk/terms.html",
      "software_client_description": name,
      "software_jwks_endpoint": "https://directory.cloudapps.digital/jwk_uri",
      "software_policy_uri": "http://trust-framework.gov.uk/policy.html",
      "software_id": SecureRandom.uuid,
      "org_contacts": [],
      "ob_registry_tos": "https://directory.cloudapps.digital/tos/",
      "org_id": SecureRandom.uuid,
      "software_logo_uri": "http://directory.cloudapps.digital/logo.jpg",
      "software_jwks_revoked_endpoint": "https://directory.cloudapps.digital/revoke",
      "software_roles": [
        "AISP",
        "PISP"
      ],
      "exp": Time.now.utc.to_i + 4 * 3600,
      "org_name": name,
      "org_jwks_revoked_endpoint": "TODO",
      "iat": Time.now.utc.to_i,
      "jti": SecureRandom.uuid
    }
  end
end
