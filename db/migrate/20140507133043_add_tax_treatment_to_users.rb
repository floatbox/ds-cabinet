class AddTaxTreatmentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tax_treatment, :string
  end
end
