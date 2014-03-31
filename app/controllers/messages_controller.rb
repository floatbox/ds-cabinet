class MessagesController < ApplicationController
  before_action :authenticate

  before_action :set_topic, only: [:index, :create]

  # Override Cancan resource loading
  before_action :set_messages, only: [:index]
  before_action :build_message, only: [:create]
  load_and_authorize_resource

  # GET /topic/:topic_id/messages
  def index
  end

  # POST /topic/:topic_id/messages
  def create
    @message.user = current_user
    @message.save
  end

  # GET /messages/:id
  def edit
    render layout: false
  end

  # PATCH /messages/:id
  def update
    @message.update_attributes(message_params)
  end

  # DELETE /messages/:id
  def destroy
    @result = @message.destroy
  end

  private

    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

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