class PagesController < ApplicationController
  def index
    @registration_enabled = ConfigItem['registration_enabled'] == 'true'
    if current_user
      redirect_url = current_user.is_concierge? ? concierge_users_url : chat_url
      redirect_to redirect_url
    end
  end

  def contacts
  end
end
