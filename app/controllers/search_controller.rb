class SearchController < ApplicationController
  layout 'chat'

  before_action :authenticate
  before_action :set_user

  # GET /users/:user_id/search
  def index
    authorize! :search, @user
    @search = Search.new(@user, params[:q])
    @topics = @search.topics
    @messages = @search.messages
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end
end