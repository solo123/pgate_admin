class AddAppidToPayResult < ActiveRecord::Migration[5.0]
  def change
    change_table :pay_results do |t|
      t.string :app_id
      t.string :channel_client_id
      t.integer :notify_times
      t.datetime :last_notify_at
    end
  end
end
