class MessageObserver < ActiveRecord::Observer

  def after_create(message)
    notify_user(message)
    notify_concierge(message)
  end

  private

    # Notify user about new messages in his topic
    def notify_user(message)
      user = message.topic.user
      unless message.user_id == user.id
        Notification.create(
          user: user,
          object: message,
          name: 'message_created'
        )
      end
    end

    # Send notification to concierge of user that has topic with new message
    def notify_concierge(message)
      if message.user.concierge
        Notification.create(
          user: message.user.concierge,
          object: message,
          name: 'message_created'
        )
      end
    end
end