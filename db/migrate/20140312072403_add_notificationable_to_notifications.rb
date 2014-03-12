class AddNotificationableToNotifications < ActiveRecord::Migration
  def change
    add_reference :notifications, :object, polymorphic: true, index: true
  end
end
