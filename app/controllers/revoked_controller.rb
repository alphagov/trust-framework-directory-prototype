class RevokedController < ApplicationController
  def revoked_organisation
    ssa = Ssa.find_by_ssa_id(params[:ssa_id])

    render json: { "revoked": ssa.revoked }
  end

  def revoked_software
    organisation = Organisation.find_by_organisation_id(params[:name])
    cert = organisation.certificates.find { |cert| cert.usage == 'signing' }

    render json: { "revoked": cert.revoked }
  end
end
