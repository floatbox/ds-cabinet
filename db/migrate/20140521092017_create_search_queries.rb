class CreateSearchQueries < ActiveRecord::Migration
  def change
    create_table :search_queries do |t|
      t.integer :user_id
      t.text :text

      t.timestamps
    end
    add_index :search_queries, :user_id
  end
end
