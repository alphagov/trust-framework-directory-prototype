class OrganisationController < ApplicationController
  def register
    Organisation.create(
      name: params[:organisation_name],
      organisation_id: params[:client_id],
      org_type: params[:organisation_type],
      domain: params[:domain],
      loa: params[:loa],
      scheme: params[:scheme]
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
    cert = org.public_send("#{params[:certificate_type]}_cert").signed_certificate
    render json: { "#{params[:certificate_type]}": cert }
  end

  def list_orgs
    if params[:organisation_type] == 'broker'
      # When a broker makes a request for a list of brokers we only want to return
      # a list of brokers which are in a different scheme
      orgs = Organisation.brokers.where.not(scheme: params[:scheme])
    else
      # When a broker makes a request for a list of IDPs we only want to return
      # a list of IDPs which are in the same scheme
      orgs = Organisation.idps.where(scheme: params[:scheme])
    end

    orgs_for_type = orgs.map do |org|
      {
        name: org.name,
        type: org.org_type,
        domain: org.domain,
        loa: org.loa,
        scheme: org.scheme
      }
    end

    render json: orgs_for_type
  end
end
