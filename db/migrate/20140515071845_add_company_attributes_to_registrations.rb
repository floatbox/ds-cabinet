class AddCompanyAttributesToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :inn, :string
    add_column :registrations, :company_name, :string
    add_column :registrations, :region_code, :string
  end
end
