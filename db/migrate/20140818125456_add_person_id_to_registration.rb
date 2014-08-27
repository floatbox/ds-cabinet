class AddPersonIdToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :person_id, :string, default:nil
  end
end
