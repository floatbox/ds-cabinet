class MessageObserver < ActiveRecord::Observer

  def after_create(message)
    notify_user(message)
    notify_concierge(message)
  end

  def after_update(message)
    notify_user(message)
    notify_concierge(message)
  end

  private

    # Notify user about new messages in his topic
    # @param message [Message] created/updated message
    def notify_user(message)
      user = message.user
      create_notification(message, user) unless message.author_id == user.id
    end

    # Sends notification to concierge of user that has topic with new message
    # @param message [Message] created/updated message
    def notify_concierge(message)
      if message.user.concierge
        create_notification(message, message.user.concierge)
      end
    end

    # Creates notification for specified user
    # @param message [Message] created/updated message
    # @param user [User] user that should recieve notification
    def create_notification(message, user)
      Notification.create(
        user: user,
        object: message,
        name: "message_#{message.id_changed? ? 'created' : 'updated'}"
      )
    end
end
