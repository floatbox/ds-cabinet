class NotificationsController < ApplicationController
  def show
    @notification = current_user.notifications.where(id: params[:id]).first
    if @notification
      @notification.update_column(:read_at, Time.now) unless @notification.read_at
      redirect_to url_to_notification(@notification)
    else
      redirect_to root_url
    end
  end

  private

    # @return [String] URL to the object of notification
    def url_to_notification(notification)
      case notification.name
      when 'user_created' then concierge_user_topics_url(notification.object)
      when 'user_attached' then concierge_user_topics_url(notification.object)
      when 'topic_created' then concierge_topic_url(notification.object)
      when 'message_created' then concierge_topic_url(notification.object.topic)
      else root_url
      end
    end
end