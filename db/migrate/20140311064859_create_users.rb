class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :siebel_id
      t.string :integration_id

      t.timestamps
    end
    add_index :users, :siebel_id
    add_index :users, :integration_id
  end
end
