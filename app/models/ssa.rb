require 'time'

class Ssa < ApplicationRecord
  belongs_to :organisation, optional: true

  include JwtAud

  CERTIFICATES = 'certificates'.freeze
  IMAGE = 'image'.freeze
  ORGANISATION = 'organisation'.freeze
  REVOKED = 'revoked'.freeze
  SOFTWARE = 'software'.freeze
  SOFTWARE_STATEMENT = "#{SOFTWARE}-statement".freeze

  def generate
    Key.create(jwk_id: ssa_id, public_key: rsa_public.to_s)
    encode(jwt_claims, jwt_header)
  end

  def certificates
    Certificate.where(ssa_id: self.ssa_id)
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
      "iss": base_url,
      "exp": Time.now.utc.to_i + 4 * 3600,
      "iat": Time.now.utc.to_i,
      "jti": SecureRandom.uuid,
      "org_id": organisation.organisation_id,
      "org_contacts": [],
      "org_jwks_endpoint": org_jwks_uri,
      "org_jwks_revoked_endpoint": org_revoked_uri,
      "org_name": SecureRandom.alphanumeric,
      "org_status": "Active",
      "organisation_competent_authority_claims": "Authorisations granted to the organsiation by an NCA",
      "software_client_id": ssa_id,
      "software_tos_uri": "http://trust-framework.gov.uk/terms.html",
      "software_client_description": organisation.organisation_id,
      "software_client_name": SecureRandom.alphanumeric,
      "software_client_uri": "The website or resource root uri",
      "software_version": "0.0.1",
      "software_environment": "production",
      "software_mode": "Live",
      "software_policy_uri": "http://trust-framework.gov.uk/policy.html",
      "software_id": SecureRandom.uuid,
      "software_jwks_endpoint": software_uri,
      "software_jwks_revoked_endpoint": software_revoked_uri,
      "software_logo_uri": logo_uri,
      "software_redirect_uris": [
        "#{base_url}/redirect"
      ],
      "software_roles": [
        "AISP",
        "PISP"
      ],
      "trust_framework_registry_tos": "#{base_url}/tos",
    }
  end

  def org_jwks_uri
    File.join(
      base_url,
      ORGANISATION,
      organisation.org_type,
      organisation.organisation_id,
      CERTIFICATES
    )
  end

  def org_revoked_uri
    File.join(base_url, REVOKED, ORGANISATION, organisation.organisation_id)
  end

  def software_uri
    File.join(
      base_url,
      ORGANISATION,
      organisation.org_type,
      organisation.organisation_id,
      SOFTWARE_STATEMENT,
      ssa_id,
      CERTIFICATES
    )
  end

  def logo_uri
    File.join(
      base_url,
      ORGANISATION,
      organisation.org_type,
      organisation.organisation_id,
      IMAGE
    )
  end

  def software_revoked_uri
    File.join(base_url, REVOKED, SOFTWARE, ssa_id)
  end

  def base_url
    @_base_url ||= Rails.application.config.base_url
  end
end
