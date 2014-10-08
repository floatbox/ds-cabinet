class AddIsSystemToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :is_system, :boolean
  end
end
