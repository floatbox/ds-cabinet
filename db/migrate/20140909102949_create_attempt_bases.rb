class CreateAttemptBases < ActiveRecord::Migration
  def change
    create_table :attempt_bases do |t|
      t.references :attemptable, polymorphic: true
      t.integer :limit, default: 0
      t.integer :count, default: 0
      t.integer :timeout, default: 0

      t.timestamps
    end
  end
end
