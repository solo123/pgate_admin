class AddRemoteIpToClientPayments < ActiveRecord::Migration[5.0]
  def change
    change_table :client_payments do |t|
      t.string :remote_ip
      t.string :uni_order_id
    end
    change_table :payment_queries do |t|
      t.rename :pay_result, :pay_code
      t.string :t0_code
      t.string :t0_desc
    end
  end
end
