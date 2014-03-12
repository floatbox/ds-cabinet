module Notificationable
  extend ActiveSupport::Concern

  included do
    has_many :notifications, as: :object
    after_destroy :destroy_notifications
  end

  module ClassMethods
  end

  private

    def destroy_notifications
      notifications.destroy_all
    end
end