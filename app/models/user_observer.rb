class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    notify_conierges_about_new_user(user)
    create_welcome_topic(user)
  end

  def after_update(user)
    user_attached(user) if user.concierge_id_changed? && user.concierge
  end

  private

    # Sends notification to all concierges about new user
    def notify_conierges_about_new_user(user)
      User.concierges.each do |concierge|
        Notification.create(
          user: concierge,
          object: user,
          name: 'user_created'
        )
      end
    end

    # Sends notification to the concierge that user was attached to
    def user_attached(user)
      Notification.create(
        user: user.concierge,
        object: user,
        name: 'user_attached'
      )
    end

    # Creates welcome topic from random concierge to new user
    def create_welcome_topic(user)
      concierge = User.concierges.order('RANDOM()').limit(1).first
      text = I18n.t('system_messages.welcome_topic')
      user.topics.create(text: text, author_id: concierge.id)
    end

end