class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    User.concierges.all.each do |concierge|
      Notification.create(
        user: concierge,
        object: user,
        name: 'user_created'
      )
    end
  end

  def after_update(user)
    user_attached(user) if user.concierge_id_changed? && user.concierge
  end

  private

    # Send notification to the concierge that user was attached to
    def user_attached(user)
      Notification.create(
        user: user.concierge,
        object: user,
        name: 'user_attached'
      )
    end

end