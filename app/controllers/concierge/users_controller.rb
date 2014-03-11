class Concierge::UsersController < Concierge::ApplicationController
  layout 'chat'

  before_action :authorize
  authorize_resource

  def index
    @users = User.common.page(params[:page]).per(10)
  end

end