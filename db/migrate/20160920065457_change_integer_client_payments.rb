class ChangeIntegerClientPayments < ActiveRecord::Migration[5.0]
  def change
    change_column :client_payments, :amount, :integer
    change_column :client_payments, :fee, :integer
  end
end
