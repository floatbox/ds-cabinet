class RegistrationsController < ApplicationController
  def new
  end

  def create
    @registration = Registration.new(registration_params)
    if @registration.save
      render json: @registration
    else
      render json: @registration.errors, status: :unprocessable_entity
    end
  end

  def complete
    @registration = Registration.find(params[:registration_id])
    head :no_content
    # TODO: implement
  end

  def regenerate_sms_verification_code
    @registration = Registration.find(params[:registration_id])
    head :no_content
    # TODO: implement
  end

  private

    def registration_params
      params.require(:registration).permit(:phone, :ogrn)
    end
end