class RecoveriesController < ApplicationController
  include WithSmsVerification

  before_action :set_recovery, only: [:verify, :set_password]

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
      redirect_to root_path
    else
      render 'verify'
    end
  end

  private

    def recovery_params
      params.require(:recovery).permit(:phone)
    end

    def set_recovery
      @recovery = Recovery.find(params[:id])
    end

end