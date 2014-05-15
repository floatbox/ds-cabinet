class RegistrationsController < ApplicationController
  include WithSmsVerification

  before_filter :set_registration, only: [:confirm, :verify_phone, :complete, :regenerate_sms_verification_code]

  def new
  end

  def create
    @registration = Registration.new(registration_params)
    if @registration.save

      if @registration.siebel_company_exists?
        @registration.defer!
      else
        @registration.register!
      end

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
      @registration.verify!

      if @registration.awaiting_password?
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
        log_in_as @registration
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

    def log_in_as(registration)
      login_info = Uas::User.login(registration.phone, registration.password)
      cookies.permanent[:auth_token] = { value: login_info.token, domain: Rails.configuration.auth_domain }
    rescue Uas::Error
      nil
    end

end