class SessionsController < ApplicationController

  protect_from_forgery with: :null_session

  # GET /sessions/new
  def new
  end

  # POST /sessions
  def create
    phone = params[:phone].to_s.gsub('(', '').gsub(')', '').gsub(' ', '').gsub('-', '')
    login_info = Uas::User.login(phone, params[:password])
    cookies.permanent[:auth_token] = { value: login_info.token, domain: Rails.configuration.auth_domain }
    render json: { redirect_to: topics_url }
  rescue Uas::Error
    head :unprocessable_entity
  end

  # DELETE /session/:session_id
  def destroy
    cookies.delete(:auth_token, domain: Rails.configuration.auth_domain)
    redirect_to root_url
  end

end
