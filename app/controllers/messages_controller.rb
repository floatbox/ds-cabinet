class MessagesController < ApplicationController
  before_action :set_topic

  def create
    @message = @topic.messages.build(message_params)
    @message.user = current_user
    if @message.save
      redirect_to topics_url
    else
      redirect_to topics_url, notice: 'Произошла ошибка'
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