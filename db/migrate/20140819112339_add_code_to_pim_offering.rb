class AddCodeToPimOffering < ActiveRecord::Migration
  def change
    add_column :pim_offerings, :code, :string, default:nil
  end
end
