class CreatePaymentQuery < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_queries do |t|
      t.belongs_to :client, index: true
      t.string :org_id
      t.string :query_type
      t.string :order_time
      t.string :order_id
      t.string :pay_result
      t.string :pay_desc
      t.string :resp_code
      t.string :resp_desc
      t.string :mac
      t.timestamps
    end
  end
end
