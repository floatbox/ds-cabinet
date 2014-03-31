class TopicObserver < ActiveRecord::Observer
  def after_create(record)
    notify_concierge(record)
    notify_user(record)
  end

  private

    # Sends notification to the user's concierge (unless concierge is the author of the topic)
    # @param record [Topic] created topic
    def notify_concierge(record)
      if record.user.concierge && record.user.concierge_id != record.author_id
        Notification.create(
          user: record.user.concierge,
          object: record,
          name: 'topic_created'
        )
      end
    end

    # Sends notification to the user this topic is related to if he is not the author of it
    # @param record [Topic] created topic
    def notify_user(record)
      unless record.user_id == record.author_id
        Notification.create(
          user: record.user,
          object: record,
          name: 'topic_created'
        )
      end
    end
end