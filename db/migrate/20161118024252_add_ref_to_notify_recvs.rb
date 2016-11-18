class AddRefToNotifyRecvs < ActiveRecord::Migration[5.0]
  def change
    add_column :notify_recvs, :ref, :string
  end
end
