class CreateSmsVerifications < ActiveRecord::Migration
  def change
    create_table :sms_verifications do |t|
      t.string :cookie
      t.string :code
      t.integer :attempts
      t.string :phone

      t.timestamps
    end
  end
end
