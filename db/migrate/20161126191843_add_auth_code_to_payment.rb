class AddAuthCodeToPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :auth_code, :string
    change_table :pay_results do |t|
      t.string :open_id
      t.string :is_subscribe
      t.string :bank_type
      t.integer :total_fee
      t.string :transaction_id
      t.string :need_query
    end

  end
end
