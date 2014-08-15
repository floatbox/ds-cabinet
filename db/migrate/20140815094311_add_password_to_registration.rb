class AddPasswordToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :password, :string, default:nil # should be cleared when registration done
  end
end
