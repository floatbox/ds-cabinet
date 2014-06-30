class Concierge::ApplicationController < ApplicationController
  before_action :authenticate_concierge

  private

    def authenticate_concierge
      redirect_to root_url unless current_user.try(:is_concierge?)
    end
end