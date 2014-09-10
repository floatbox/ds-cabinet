class FeedbackController < ApplicationController
  respond_to :json

  def create
    #render json: { message: t('.success') }
    render json: { base: [t('.fail')] }, status: :unprocessable_entity
  end
end
