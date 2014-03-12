class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    if user.persisted?
      can :manage, User, id: user.id
      can :read, Topic, user_id: user.id
      can :create, [Topic, Message]
      can :manage, [Topic, Message] do |record|
        record.user_id == user.id && 3.days.since(record.created_at) > Time.now
      end
      can :manage, Notification, user_id: user.id
    end

    if user.concierge?
      can :read, User
      can [:read, :create, :update, :destroy], User
      can :attach_concierge, User, concierge_id: [nil, user.id]
      can :manage, Topic
      can :read, Message
    end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
