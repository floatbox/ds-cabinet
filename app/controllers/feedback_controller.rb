class FeedbackController < ApplicationController
  respond_to :json

  def create
    begin
      RegistrationMailer.feedback_email(params).deliver

      render json: { message: t('.success') }
    rescue => exception
      logger.error "Error occured. #{exception.message}"
      render json: { base: [t('.fail')] }, status: :unprocessable_entity
    end
  end
end
