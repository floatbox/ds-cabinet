# Model that represents attempts of doig something, e.g. attempts to log in, 
#   or attempts to resend password sms notification
#
# Real action attempt should be a successor of that model, see 
#   #Attempt::RegistrationPasswordNotification
#
class Attempt::Base < ActiveRecord::Base
  
  belongs_to :attemptable, polymorphic: true

  validate :validate_exausted, unless: :new_record?
  validate :validate_timeout, unless: [:exausted?, :new_record?]

  def inc!
    @updated_at = updated_at
    update! count: count + 1
    timeout.seconds
  end

  def reset
    update_column :count, 0
    self.errors.clear
  end

  protected

  def validate_exausted
    errors.add(:limit, :exausted) if exausted?
  end

  def validate_timeout
    errors.add(:timeout, :not_expired) if timeout?
  end

  def exausted?
    count > limit
  end

  def timeout?
    @updated_at && (@updated_at + timeout > Time.zone.now)
  end
end
