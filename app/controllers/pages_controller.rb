class PagesController < ApplicationController
  def index
    if current_user
      redirect_url = current_user.concierge? ? concierge_users_url : topics_url
      redirect_to redirect_url
    end
  end

  def contacts
  end
end