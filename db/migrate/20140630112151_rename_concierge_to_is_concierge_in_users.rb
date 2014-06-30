class RenameConciergeToIsConciergeInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :concierge, :is_concierge
  end
end
