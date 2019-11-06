class RevokedController < ApplicationController
  def revoked_organisation
    organisation = Organisation.find_by_organisation_id(params[:name])

    render json: { "revoked": organisation.revoked }
  end

  def revoked_software
    ssa = Ssa.find_by_ssa_id(params[:ssa_id])

    render json: { "revoked": ssa.revoked }
  end
end
