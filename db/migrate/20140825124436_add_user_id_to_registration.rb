class AddUserIdToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :user_id, :integer, references: :users
  end
end
