class Concierge::ApplicationController < ApplicationController
  before_action :authorize_concierge

  private

    def authorize_concierge
      redirect_to root_url unless current_user.try(:concierge?)
    end
end