class Concierge::TopicsController < Concierge::ApplicationController
  layout 'chat'

  before_action :authorize
  authorize_resource

  def index
    @topics = Topic.order('created_at DESC').page(params[:page]).per(10)
  end

  private

    def topic_params
      params.require(:topic).permit(:text)
    end
end