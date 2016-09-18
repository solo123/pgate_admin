class AddRedirectUrlToClientPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :client_payments, :redirect_url, :string
  end
end
