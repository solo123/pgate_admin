class AddAttachToClientPayment < ActiveRecord::Migration[5.0]
  def change
    change_table :client_payments do |t|
      t.string :attach_info
      t.string :sp_udid
      t.datetime :pay_time
      t.datetime :close_time
      t.string :refund_id
    end
  end
end
