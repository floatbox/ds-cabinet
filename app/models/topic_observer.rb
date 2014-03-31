class TopicObserver < ActiveRecord::Observer
  def after_create(record)
    # Send notification to the user's concierge (unless concierge is the author of the topic)
    if record.user.concierge && record.user.concierge_id != record.author_id
      Notification.create(
        user: record.user.concierge,
        object: record,
        name: 'topic_created'
      )
    end
  end
end