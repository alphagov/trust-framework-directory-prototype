class OrganisationController < ApplicationController
  def register
    Organisation.create(
      name: params[:organisation_name],
      organisation_id: params[:client_id],
      org_type: params[:organisation_type],
      domain: params[:domain],
      loa: params[:loa],
      brand_image: params[:brand_image],
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

  def get_decoded_image
    org = Organisation.find_by_organisation_id(params[:organisation_id])
    send_data Base64.decode64(org.brand_image), :type => "image/svg+xml", :disposition => 'inline'
  end

  def get_decoded_image_by_scheme
    org = Organisation.find_by(org_type: 'broker', scheme: params[:scheme])
    send_data Base64.decode64(org.brand_image), :type => "image/svg+xml", :disposition => 'inline'
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
    elsif params[:organisation_type] == 'rp'
      # When an RP makes a request for a list of brokers we only want to return
      # a list of brokers which are in the same scheme. There should only ever be
      # one. Maybe.
      orgs = Organisation.brokers.where(scheme: params[:scheme])
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
        scheme: org.scheme,
        id: org.organisation_id
      }
    end

    render json: orgs_for_type
  end
end
