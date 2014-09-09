require 'phone'
require 'ogrn'

class RegistrationsController < ApplicationController
  include WithSmsVerification

  before_filter :check_registration_enabled
  before_filter :set_registration, only: [:confirm, :regenerate_password]

  def create
    phone= params[:registration].try :[], :phone
    ogrn=  params[:registration].try :[], :ogrn

    errors = Registration.new.errors
    if ogrn.nil? || ogrn.empty?  
      errors.add(:ogrn, :blank)
    elsif !Ogrn.new(ogrn).valid? 
      errors.add(:ogrn, :wrong_value)
    end
    
    if phone.nil? || phone.empty?
      errors.add(:phone, :blank)
    elsif !Phone.new(phone).valid? 
      errors.add(:phone, :wrong_value)
    end

    unless errors.empty?
      render json: errors, status: :unprocessable_entity
    else
      @registration = Registration.find_by_phone_ogrn phone, ogrn
      if @registration
        @registration.send_password_sms_notification
        render json: @registration.as_json(only: [:id, :ogrn, :phone])
      else
        # external systems are called here by implicit call company and ogrn
        @registration = Registration.new(registration_params) 
        if @registration.save
          if @registration.siebel_company_exists?
            @registration.defer!
          else
            generate_send_password
            @registration.start!
          end

          render json: @registration.as_json(only: [:id, :ogrn, :phone])
        else
          # Notify admins about invalid OGRN, but valid phone
          @registration.notify_admin if @registration.errors.messages.keys == [:company]

          # Render JSON with errors
          render json: @registration.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # That confirms OGRN, company_name, phone and password
  def confirm
    if @registration.password == params[:password]
      @registration.send_to_ds!
      @registration.confirm! if @registration.workflow_state == "awaiting_confirmation"
      @registration.notify_admin
      log_in_as @registration
      head :no_content
    else
      @registration.errors.add(:password, :wrong_value)
      render json: @registration.errors, status: :unprocessable_entity
    end
  end

  def regenerate_password
    generate_send_password
    head :no_content
  rescue ActiveRecord::RecordInvalid => e
    render json: e.record.errors, status: :unprocessable_entity
  end

  private
    def generate_send_password
      @registration.password = PasswordGenerator.generate
      @registration.password_confirmation = @registration.password

      pna = @registration.password_notification_attempts
      pna.nil? ? @registration.create_password_notification_attempts : pna.inc!
      
      logger.info([
        "REGISTRATION LOGIN=='#{@registration.phone}'", 
        " PASSWORD=='#{@registration.password}'"].join) unless Rails.env.production?

      @registration.update_column(:password, @registration.password) unless 
        Rails.env.production?

      @registration.send_password_sms_notification
    end

    def check_registration_enabled
      render nothing: true unless ConfigItem['registration_enabled'] == 'true'
    end

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
