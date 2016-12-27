class AddD0ToPayments < ActiveRecord::Migration[5.0]
  def change
    change_table :payments do |t|
      t.integer :redirect, default: 0
      t.integer :is_d0, default: 0
    end
  end
end
