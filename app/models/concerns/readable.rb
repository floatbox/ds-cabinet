# Adds read/unread logic to the model
module Readable
  extend ActiveSupport::Concern

  included do
    scope :unread, -> { where(read_at: nil) }
  end

  module ClassMethods
  end

  def read_by(current_user)
    if unread? && user.concierge_id == current_user.id
      update_column(:read_at, Time.now)
    end
    after_read_by(current_user)
  end

  def unread?
    read_at.nil?
  end

  def after_read_by(user)
    nil
  end

end