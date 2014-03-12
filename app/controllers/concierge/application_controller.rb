class Concierge::ApplicationController < ApplicationController
  before_action :authenticate_concierge

  private

    def authenticate_concierge
      redirect_to root_url unless current_user.try(:concierge?)
    end
end