class RegistrationsController < ApplicationController
  include WithSmsVerification

  before_filter :set_registration, only: [:confirm, :complete, :regenerate_sms_verification_code]

  def new
  end

  def create
    @registration = Registration.new(registration_params)
    if @registration.save
      @registration.register!
      render json: @registration
    else
      render json: @registration.errors, status: :unprocessable_entity
    end
  end

  def confirm
    if generate_sms_verification_code(@registration.phone)
      @registration.confirm!
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def complete
    @registration.password = params[:password]
    if @registration.valid?
      success = -> { head :no_content }
      error = -> { render json: { sms_verification_code: ['неверный код подтверждения'] }, status: :unprocessable_entity }
      with_sms_verification(@registration.phone, success, error)
    else
      render json: @registration.errors, status: :unprocessable_entity
    end
  end

  def regenerate_sms_verification_code
    if generate_sms_verification_code(@registration.phone)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

    def registration_params
      params.require(:registration).permit(:phone, :ogrn)
    end

    def set_registration
      @registration = Registration.find(params[:registration_id])
    end
end