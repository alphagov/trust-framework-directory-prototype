class OrganisationController < ApplicationController
  def register
    Organisation.create(
      name: params[:organisation_name],
      organisation_id: params[:client_id],
      org_type: params[:organisation_type],
      domain: params[:domain],
      loa: params[:loa]
    )
  end

  def certificates
    org = Organisation.find_by_organisation_id(params[:organisation_id])
    render json: {
      "signing": org.signing_cert.signed_certificate,
      "transport": org.transport_cert.signed_certificate
    }
  end

  def get_certificate
    org = Organisation.find_by_organisation_id(params[:organisation_id])
    cert = org.public_send("#{params[:certificate_type]}_certificate").signed_certificate
    render json: { "#{params[:certificate_type]}": cert }
  end

  def list_orgs
    orgs = Organisation.where(org_type: params[:organisation_type], revoked: false).map do |org|
      {
        name: org.name,
        type: org.org_type,
        domain: org.domain,
        loa: org.loa
      }
    end

    render json: orgs
  end
end
