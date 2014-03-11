class AddConciergeIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :concierge_id, :integer
    add_index :users, :concierge_id
  end
end
