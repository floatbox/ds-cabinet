class PagesController < ApplicationController
  def index
    redirect_to topics_url if current_user
  end
end