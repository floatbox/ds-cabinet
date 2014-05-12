class RecoveriesController < ApplicationController
  include WithSmsVerification

  before_action :set_recovery, only: [:verify, :set_password, :regenerate_sms_verification_code]

  # GET /recoveries/new
  def new
    @recovery = Recovery.new
  end

  # POST /recoveries
  def create
    @recovery = Recovery.new(recovery_params)
    if @recovery.save
      generate_sms_verification_code(@recovery.phone)
    else
      render 'new'
    end
  end

  # POST /recoveries/:id/verify
  def verify
    if with_sms_verification(@recovery.phone)
      @recovery.verify!
    else
      @recovery.errors.add(:base, :invalid_sms_verification_code)
      render 'create'
    end
  end

  # POST /recoveries/:id/set_password
  def set_password
    @recovery.password = params[:recovery][:password]
    @recovery.password_confirmation = params[:recovery][:password_confirmation]
    @recovery.set_password!
    if @recovery.done?
      log_in_as @recovery
      redirect_to root_path
    else
      render 'verify'
    end
  end

  # POST /recoveries/:id/regenerate_sms_verification_code
  def regenerate_sms_verification_code
    if generate_sms_verification_code(@recovery.phone)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

    def recovery_params
      params.require(:recovery).permit(:phone)
    end

    def set_recovery
      @recovery = Recovery.find(params[:id])
    end

    def log_in_as(recovery)
      login_info = Uas::User.login(recovery.phone, recovery.password)
      cookies.permanent[:auth_token] = { value: login_info.token, domain: Rails.configuration.auth_domain }
    rescue Uas::Error
      nil
    end

end