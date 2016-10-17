class AddAttachToClientPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :client_payments, :attach_info, :string
    add_column :client_payments, :sp_udid, :string
  end
end
