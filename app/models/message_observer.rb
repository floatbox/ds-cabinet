class MessageObserver < ActiveRecord::Observer
  def after_create(record)
    if record.user.concierge
      Notification.create(
        user: record.user.concierge,
        object: record,
        name: 'message_created'
      )
    end
  end
end