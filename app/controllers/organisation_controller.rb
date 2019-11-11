class OrganisationController < ApplicationController
  def register
    Organisation.create(organisation_id: params[:client_id], org_type: 'service')
  end

  def certificates
    org = Organisation.find_by_organisation_id(params[:organisation_id])
    render json: {
      "signing": org.signing_cert.public_key,
      "transport": org.transport_cert.public_key
    }
  end

  def get_certificate
    org = Organisation.find_by_organisation_id(params[:organisation_id])
    cert = org.public_send("#{params[:certificate_type]}_certificate").signed_certificate
    render json: { "#{params[:certificate_type]}": cert }
  end
end
