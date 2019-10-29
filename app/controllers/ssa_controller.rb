class SsaController < ApplicationController
  def index
    render json: { hello: 'world' }
  end

  def generate
    render json: { jws: Ssa.new(name: params[:name], ssa_id: params[:ssa_id]).generate }
  end
end
