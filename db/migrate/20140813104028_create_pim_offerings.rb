class CreatePimOfferings < ActiveRecord::Migration
  def change
    create_table :pim_offerings do |t|
      t.string :offering_id,   :null => false
      t.string  :price_text,   :null => false
      t.string  :price_id,     :null => false
      t.float   :price_amount, :null => false
      t.string  :price_unit
      t.integer :price_unit_qty

      t.string  :type # STI

      # Purchases
      t.boolean    :paid, default: false
      t.datetime   :payment_date
      t.references :user
      t.references :registration

      t.timestamps
    end
  end
end
