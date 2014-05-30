class AddIsUserConciergeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_super_concierge, :boolean, default: false
  end
end
