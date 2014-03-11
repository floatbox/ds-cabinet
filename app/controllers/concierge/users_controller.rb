class Concierge::UsersController < Concierge::ApplicationController
  layout 'chat'

  before_action :authorize
  authorize_resource

  def index
    @users = User.common.page(params[:page]).per(10)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to concierge_users_url
    else
      render 'edit', alert: 'Не удалось сохранить'
    end
  end

  private

    def user_params
      params.require(:user).permit(:concierge_id)
    end
end