class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.string :phone
      t.string :ogrn

      t.timestamps
    end
  end
end
