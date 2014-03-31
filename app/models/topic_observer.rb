class TopicObserver < ActiveRecord::Observer
  def after_create(record)
    notify_concierge(record)
    notify_user(record)
  end

  def after_update(record)
    notify_concierge(record)
    notify_user(record)
  end

  private

    # Sends notification to the user's concierge (unless concierge is the author of the topic)
    # @param record [Topic] created/updated topic
    def notify_concierge(record)
      if record.user.concierge && record.user.concierge_id != record.author_id
        create_notification(record, record.user.concierge)
      end
    end

    # Sends notification to the user this topic is related to if he is not the author of it
    # @param record [Topic] created/updated topic
    def notify_user(record)
      unless record.user_id == record.author_id
        create_notification(record, record.user)
      end
    end

    # Creates notification for specified user
    # @param record [Topic] created/updated topic
    # @param user [User] user that should recieve notification
    def create_notification(record, user)
      Notification.create(
        user: user,
        object: record,
        name: "topic_#{record.id_changed? ? 'created' : 'updated'}"
      )
    end
end