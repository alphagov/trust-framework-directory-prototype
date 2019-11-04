class SsaController < ApplicationController
  def index
    render json: { hello: 'world' }
  end

  def generate
    # TO DO
    # validate token from tpp

    ssa = Ssa.new(
      name: params[:name],
      ssa_id: params[:ssa_id],
      base_url: request.base_url
    ).generate

    ## TO DO
    ## save something about the ssa to a jwk_uri
    render plain: ssa
  end
end
