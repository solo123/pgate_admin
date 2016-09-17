class AddRespToClientPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :client_payments, :resp_code, :string
    add_column :client_payments, :resp_desc, :string
  end
end
