class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :user_id
      t.text :text

      t.timestamps
    end
    add_index :topics, :user_id
  end
end
