class MessagesController < ApplicationController
  before_action :set_topic

  before_action :authorize
  authorize_resource

  def create
    @message = @topic.messages.build(message_params)
    @message.user = current_user
    redirect_url = current_user.concierge? ? concierge_topic_url(@topic) : topic_url(@topic)
    if @message.save
      redirect_to redirect_url
    else
      redirect_to redirect_url, notice: 'Произошла ошибка'
    end
  end

  private

    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    def message_params
      params.require(:message).permit(:text)
    end
end