class AddUasUserToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :uas_user, :text, default:nil # serialized Uas::User object
  end
end
