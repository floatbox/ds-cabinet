class AddAuthorIdToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :author_id, :integer
    add_index :topics, :author_id
  end
end