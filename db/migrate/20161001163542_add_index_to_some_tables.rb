class AddIndexToSomeTables < ActiveRecord::Migration[5.0]
  def change
    add_index :client_payments, :org_id
    add_index :client_payments, :order_id
    add_index :kaifu_gateways, :organization_id
    add_index :kaifu_gateways, :send_seq_id
  end
end
