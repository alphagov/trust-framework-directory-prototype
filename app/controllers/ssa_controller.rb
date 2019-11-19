class SsaController < ApplicationController
  BEARER = /^Bearer /.freeze

  def index
    render json: { hello: 'world' }
  end

  def generate
    organisation = Organisation.find_by_organisation_id(params[:organisation_id])

    ## in real life we would validate this properly!!!
    if organisation.access_token == access_token
      ssa = Ssa.create(organisation_id: organisation.id, ssa_id: params[:ssa_id])
      ssa.statement = ssa.generate
      ssa.save!

      render plain: ssa.statement
    else
      render plain: 'Access token invalid'
    end
  end

  def get_ssa
    ssa = Ssa.find_by_ssa_id(params[:ssa_id])
    render plain: ssa.statement
  end

  def get_certificates
    org = Organisation.find_by_organisation_id(params[:organisation_id])
    certs = org.ssa_certificates(params[:ssa_id])
    render json: {
      "signing": certs.where(usage: 'signing').first.public_key,
      "transport": certs.where(usage: 'transport').first.public_key
    }
  end

private

  def access_token
    header = request.headers['Authorization']
    header.gsub(BEARER, '') if header && header.match(BEARER)
  end
end
