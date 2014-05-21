class CreateShortcuts < ActiveRecord::Migration
  def change
    create_table :shortcuts do |t|
      t.text :question
      t.text :answer

      t.timestamps
    end
  end
end
