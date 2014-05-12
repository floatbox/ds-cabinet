class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    notify_conierges_about_new_user(user)
    assign_random_concierge_to(user)
    create_welcome_topic_for(user)
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

    # Finds random concierge and assigns him to the newly created user
    def assign_random_concierge_to(user)
      concierge = User.concierges.order('RANDOM()').limit(1).first
      user.concierge = concierge
      user.save
    end

    # Creates welcome topic from the concierge to the user
    def create_welcome_topic_for(user)
      text = I18n.t('system_messages.welcome_topic')
      user.topics.create(text: text, author_id: user.concierge.id)
    end

end