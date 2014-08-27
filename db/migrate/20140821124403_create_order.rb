class CreateOrder < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.text       :cart_order
      t.datetime   :payment_date
      t.references :orderable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
