class SsaController < ApplicationController
  BEARER = /^Bearer /.freeze

  def index
    render json: { hello: 'world' }
  end

  def generate
    organisation = Organisation.find_by_organisation_id(params[:name])

    ## in real life we would validate this properly!!!
    if organisation.access_token == access_token
      ssa = Ssa.create(organisation_id: organisation.id, ssa_id: params[:ssa_id])
      ssa.statement = ssa.generate
      ssa.save!

      render plain: ssa.statement
    else
      render plain: 'Nope'
    end
  end

  def access_token
    header = request.headers['Authorization']
    header.gsub(BEARER, '') if header && header.match(BEARER)
  end
end
