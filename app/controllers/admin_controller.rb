class AdminController < ApplicationController
  def index
    @brokers = Organisation.brokers
    @idps = Organisation.idps

    render :index
  end

  def delete_selected
    org_type = ['broker', 'idp'].find { |type| params.keys.include?(type) }
    Organisation.delete(params[org_type])

    redirect_to :admin
  end

  def delete_by_org_type
    Organisation.where(org_type: params[:organisation_type]).destroy_all

    redirect_to :admin
  end
end
