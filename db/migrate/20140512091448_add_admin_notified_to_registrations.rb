class AddAdminNotifiedToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :admin_notified, :boolean, default: false
  end
end
