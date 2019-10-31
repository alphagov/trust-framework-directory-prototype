class SsaController < ApplicationController
  def index
    render json: { hello: 'world' }
  end

  def generate
    # validate token from tpp
    ssa = Ssa.new(name: params[:name], ssa_id: params[:ssa_id]).generate
    ## save something about the ssa to a jwk_uri
    render plain: ssa
  end
end
