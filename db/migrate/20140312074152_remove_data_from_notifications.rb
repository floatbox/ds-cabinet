class RemoveDataFromNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :data, :text
  end
end
