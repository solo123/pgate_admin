class AddNotifyRespToClientPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :client_payments, :pay_code, :string
    add_column :client_payments, :pay_desc, :string
    add_column :client_payments, :t0_code, :string
    add_column :client_payments, :t0_desc, :string

    add_column :kaifu_results, :kaifu_gateway_id, :integer
    remove_column :kaifu_results, :recv_post_id, :integer
    add_reference :kaifu_results, :sender, polymorphic: true, index: true
  end
end
