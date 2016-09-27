class AddClientPaymentToPaymentQuery < ActiveRecord::Migration[5.0]
  def change
    add_column :payment_queries, :client_payment_id, :integer
  end
end
