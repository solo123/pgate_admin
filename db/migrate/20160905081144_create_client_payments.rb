class CreateClientPayments < ActiveRecord::Migration
  def change
    create_table :client_payments do |t|
      t.belongs_to :client, index: true
      t.string :org_id
      t.string :trans_type
      t.string :order_time
      t.string :order_id
      t.string :order_title
      t.string :pay_pass
      t.string :img_url
      t.string :amount
      t.string :fee
      t.string :card_no
      t.string :card_holder_name
      t.string :person_id_num
      t.string :notify_url
      t.string :callback_url
      t.string :mac
      t.datetime :finish_time
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
