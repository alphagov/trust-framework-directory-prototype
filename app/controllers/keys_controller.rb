class KeysController < ApplicationController
  def org_private_keys
    org = Organisation.find_by_organisation_id(params[:organisation_id])

    render json: {
      signing: org.signing_cert.private_key,
      transport: org.transport_cert.private_key
    }
  end
end
