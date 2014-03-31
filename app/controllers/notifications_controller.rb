# This controller manages notifications.
# All its actions work with the notifications of current user only.
class NotificationsController < ApplicationController
  before_action :set_user, only: :index
  load_and_authorize_resource

  # GET /notifications
  # Returns paginated list of all notifications
  def index
    @notifications = @notifications.page(params[:page]).per(5)
  end

  # GET /notifications/unread
  # Returns paginated list of unread notifications only
  def unread
    @notifications = current_user.notifications.unread.page(params[:page]).per(5)
  end

  # GET /notifications/:id
  # Marks notification as read and redirects to its object
  def show
    @notification.update_column(:read_at, Time.now) unless @notification.read_at
    redirect_to url_to_notification(@notification)
  end

  private

    # @return [String] URL to the object of notification
    def url_to_notification(notification)
      case notification.name
      when 'user_created' then concierge_user_topics_url(notification.object)
      when 'user_attached' then concierge_user_topics_url(notification.object)
      when 'topic_created' then current_user.concierge? ? concierge_topic_url(notification.object) : topic_url(notification.object)
      when 'message_created' then current_user.concierge? ? concierge_topic_url(notification.object.topic) : topic_url(notification.object.topic)
      else root_url
      end
    end
end