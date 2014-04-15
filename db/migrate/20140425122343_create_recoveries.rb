class CreateRecoveries < ActiveRecord::Migration
  def change
    create_table :recoveries do |t|
      t.string :phone
      t.string :workflow_state

      t.timestamps
    end
  end
end
