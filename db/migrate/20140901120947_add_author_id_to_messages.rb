class AddAuthorIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :author_id, :integer
    add_index :messages, :author_id
  end
end
