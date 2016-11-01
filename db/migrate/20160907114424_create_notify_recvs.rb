class CreateNotifyRecvs < ActiveRecord::Migration
  def change
    create_table :notify_recvs do |t|
      t.string :method
      t.string :sender
      t.string :send_host
      t.text :params
      t.text :data
      t.text :result_message
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
