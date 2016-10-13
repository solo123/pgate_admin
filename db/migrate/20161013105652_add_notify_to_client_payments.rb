class AddNotifyToClientPayments < ActiveRecord::Migration[5.0]
  def change
    change_table :client_payments do |t|
      t.integer :notify_times, default: 0
      t.integer :notify_status, default: 0
      t.datetime :last_notify
    end

  end
end
