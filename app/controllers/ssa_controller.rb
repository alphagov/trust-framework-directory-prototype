class SsaController < ApplicationController
  BEARER = /^Bearer /.freeze

  def index
    render json: { hello: 'world' }
  end

  def generate
    organisation = Organisation.find_by_organisation_id(params[:name])

    ## in real life we would validate this properly!!!
    if organisation.access_token == access_token
      ssa = Ssa.new(
        name: params[:name],
        ssa_id: params[:ssa_id],
        base_url: request.base_url
      ).generate

      ## TO DO
      ## save something about the ssa to a jwk_uri
      render plain: ssa
    else
      render plain: 'Nope'
    end
  end

  def access_token
    header = request.headers['Authorization']
    header.gsub(BEARER, '') if header && header.match(BEARER)
  end
end
