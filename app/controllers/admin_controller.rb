class AdminController < ApplicationController
  def index
    scheme_hash = Organisation.all.group_by(&:scheme)
    @schemes = {}
    scheme_hash.each { |scheme, orgs| @schemes[scheme] = orgs.group_by(&:org_type) }

    render :index
  end

  def delete_selected
    org = Organisation.find_by_id(params[:org_id])

    if org
      Organisation.destroy(params[:org_id])
      flash[:success] = "Deleted #{org.org_type} #{org.name}"
    else
      flash[:error] = "Organisation with ID '#{params[:org_id]}' does not exist"
    end

    redirect_to :admin
  end

  def delete_by_org_type
    Organisation.where(org_type: params[:organisation_type]).destroy_all
    flash[:success] = "Deleted all organsiations of type #{params[:organisation_type]}"

    redirect_to :admin
  end
end
