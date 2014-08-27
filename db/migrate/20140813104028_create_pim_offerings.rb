class CreatePimOfferings < ActiveRecord::Migration
  def change
    create_table :pim_offerings do |t|
      t.string  :offering_id,           :null => false
      t.string  :offering_price_id,     :null => false
      t.string  :text,   :null => false
      t.float   :amount, :null => false
      t.string  :unit
      t.integer :unit_qty
      t.string  :type # STI

      # Purchases
      t.references :user
      t.string     :code, default:nil

      t.timestamps
    end
  end
end
