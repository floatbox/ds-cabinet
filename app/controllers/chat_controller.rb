class ChatController < ApplicationController
  before_action :authenticate, only: [:index, :update, :destroy]
  before_action :authenticate_with_response, only: [:edit]

  # Override Cancan resource loading
  # before_action :set_messages, only: [:index]
  before_action :build_message, only: [:create]
  # load_and_authorize_resource

  # GET /chat
  def index
    @messages = current_user.messages.published
    @new_message = current_user.authored_messages.build
    @new_message.user = current_user
  end

  private

    def set_messages
      @messages = @topic.messages
    end

    def build_message
      @message = @topic.messages.build(message_params)
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
