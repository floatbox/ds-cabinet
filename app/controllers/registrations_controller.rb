class RegistrationsController < ApplicationController
  include WithSmsVerification

  before_filter :set_registration, only: [:confirm, :verify_phone, :complete, :regenerate_sms_verification_code]

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
      @registration.errors.add(:base, :something_went_wrong)
      render json: @registration.errors, status: :unprocessable_entity
    end
  end

  def verify_phone
    if with_sms_verification(@registration.phone)

      if @registration.siebel_company_exists?
        @registration.verify_and_defer!
      else
        @registration.verify!
      end

      if @registration.awaiting_password? || @registration.verified_and_deferred?
        render json: { status: @registration.workflow_state }
      else
        @registration.errors.add(:base, :something_went_wrong)
        render json: @registration.errors, status: :unprocessable_entity
      end

    else
      render json: { sms_verification_code: ['неверный код подтверждения'] }, status: :unprocessable_entity
    end
  end

  def complete
    @registration.password = params[:password]
    @registration.password_confirmation = params[:password_confirmation]
    if @registration.valid?
      @registration.send_to_ds!
      if @registration.done?
        @registration.notify_admin
        head :no_content
      else
        @registration.errors.add(:base, :something_went_wrong)
        render json: @registration.errors, status: :unprocessable_entity
      end
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