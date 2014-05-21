class CreateConfigItems < ActiveRecord::Migration
  def change
    create_table :config_items do |t|
      t.string :key
      t.text :value
      t.text :default

      t.timestamps
    end
  end
end
