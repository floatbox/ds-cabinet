class DemoController < ApplicationController

  # GET /demo
  def index
    @current_user = User.find Rails.configuration.demo_user_id
    @messages = @current_user.messages.published
    @new_message = @current_user.authored_messages.build
    @new_message.user = @current_user
    render 'chat/index', layout: 'chat'
  end

end
