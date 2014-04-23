class AddReadAtToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :read_at, :datetime
  end
end
