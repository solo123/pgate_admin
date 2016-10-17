class AddPayToTfbOrders < ActiveRecord::Migration[5.0]
  def change
    change_table :tfb_orders do |t|
      t.string :tran_state
      t.string :refund_state
      t.string :state
      t.datetime :pay_time
      t.datetime :close_time
      t.string :refund_listid
    end

  end
end
