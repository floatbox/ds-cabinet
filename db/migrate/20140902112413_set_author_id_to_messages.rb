class SetAuthorIdToMessages < ActiveRecord::Migration
  def up
    execute 'UPDATE messages SET author_id = user_id'
  end

  def down
  end
end
