class KeysController < ApplicationController
  def org_private_keys
    org = Organisation.find_by_organisation_id(params[:organisation_id])

    if org
      render json: {
        signing: org.signing_cert.private_key,
        transport: org.transport_cert.private_key
      },
      status: :ok
    else
      render json: {
        error: "No organisation found for #{params[:organisation_id]}"
      },
      status: :not_found
    end
  end
end
