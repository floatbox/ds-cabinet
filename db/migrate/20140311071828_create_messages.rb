class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :topic_id
      t.integer :user_id
      t.text :text

      t.timestamps
    end
    add_index :messages, :topic_id
    add_index :messages, :user_id
  end
end
