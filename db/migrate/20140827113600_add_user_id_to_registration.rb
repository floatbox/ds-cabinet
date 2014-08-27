class AddUserIdToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :user_id, :integer, references: "users", default:nil
  end
end
