class AddConciergeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :concierge, :boolean, default: false
  end
end
