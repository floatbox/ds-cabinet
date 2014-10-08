class AddPromocodeToPimOfferings < ActiveRecord::Migration
  def change
    add_column :pim_offerings, :promocode, :string
  end
end
