class AddContactIdToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :contact_id, :string, default:nil
  end
end
