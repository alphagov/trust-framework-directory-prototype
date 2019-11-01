class OnboardController < ApplicationController
  def confirm
    render json: { welcome: 'to The Future' }
  end
end
