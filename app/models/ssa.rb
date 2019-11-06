require 'time'

class Ssa < ApplicationRecord
  belongs_to :organisation, optional: true

  include JwtAud

  def generate
    Key.create(jwk_id: ssa_id, public_key: rsa_public.to_s)
    encode(jwt_claims, jwt_header)
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
      "iss": base_url,
      "exp": Time.now.utc.to_i + 4 * 3600,
      "iat": Time.now.utc.to_i,
      "jti": SecureRandom.uuid,
      "org_id": organisation.organisation_id,
      "org_contacts": [],
      "org_jwks_endpoint": org_jwks_uri,
      "org_jwks_revoked_endpoint": org_revoked_uri,
      "org_name": organisation.organisation_id,
      "org_status": "Active",
      "software_client_id": ssa_id,
      "software_tos_uri": "http://trust-framework.gov.uk/terms.html",
      "software_client_description": organisation.organisation_id,
      "software_mode": "TEST",
      "software_policy_uri": "http://trust-framework.gov.uk/policy.html",
      "software_id": ssa_id,
      "software_jwks_endpoint": software_uri,
      "software_jwks_revoked_endpoint": software_revoked_uri,
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

  def org_jwks_uri
    File.join(base_url, 'jwk-uri', 'organisation', organisation.organisation_id)
  end

  def org_revoked_uri
    File.join(base_url, 'revoked', 'organisation', organisation.organisation_id)
  end

  def software_uri
    File.join(base_url, 'jwk-uri', 'software', ssa_id)
  end

  def software_revoked_uri
    File.join(base_url, 'revoked', 'software', ssa_id)
  end

  def base_url
    @_base_url ||= Rails.application.config.base_url
  end
end
