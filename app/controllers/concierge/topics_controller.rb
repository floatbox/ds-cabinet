class Concierge::TopicsController < Concierge::ApplicationController
  layout 'chat'

  before_action :set_user

  before_action :authorize
  authorize_resource

  def index
    if @user
      @topics = @user.topics.order('created_at DESC').page(params[:page]).per(10)
    else
      @topics = Topic.order('created_at DESC').page(params[:page]).per(10)
    end
  end

  private

    def set_user
      @user = User.find(params[:user_id]) if params[:user_id]
    end

    def topic_params
      params.require(:topic).permit(:text)
    end
end