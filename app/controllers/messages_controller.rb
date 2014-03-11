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
      fix_attachment_ids
      params.require(:message).permit(:text, attachment_ids: [])
    end

    def fix_attachment_ids
      if params[:message][:attachment_ids] == '[]'
        params[:message][:attachment_ids] = nil
      elsif params[:message][:attachment_ids]
        params[:message][:attachment_ids] = params[:message][:attachment_ids].split(',')
      end
    end
end