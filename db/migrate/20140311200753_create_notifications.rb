class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.datetime :read_at
      t.string :name
      t.text :data

      t.timestamps
    end
    add_index :notifications, :user_id
  end
end
