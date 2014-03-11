class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

private

  # @return [Uas::User] currently logged in user
  def current_user
    token = request.cookies['auth_token']
    @current_user ||= User.find_by_token(token) if token
  end
  helper_method :current_user

  # Add this method to before_action to authorize access.
  # @example before_filter :authorize
  def authorize
    redirect_to root_url if current_user.nil?
  end
end
