module API
  class APIController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :authenticate

    protected

      def authenticate
        authenticate_token || render_unauthorized
      end

      # Only concierge can authenticate
      def authenticate_token
        authenticate_with_http_token do |token, options|
          @current_user = User.concierges.find_by(api_token: token)
        end
      end

      def render_unauthorized
        self.headers['WWW-Authenticate'] = 'Token realm="Application"'
        render json: 'Bad credentials', status: 401
      end
  end
end