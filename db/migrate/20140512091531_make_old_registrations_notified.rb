class MakeOldRegistrationsNotified < ActiveRecord::Migration
  def up
    execute 'UPDATE registrations SET admin_notified=true'
  end

  def down
  end
end
