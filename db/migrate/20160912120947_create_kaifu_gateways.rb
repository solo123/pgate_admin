class CreateKaifuGateways < ActiveRecord::Migration[5.0]
  def change
    create_table :kaifu_gateways do |t|
      t.belongs_to :client_payment, index: true
      t.string :send_time
      t.string :send_seq_id
      t.string :trans_type
      t.string :organization_id
      t.string :pay_pass
      t.string :img_url
      t.string :trans_amt
      t.string :fee
      t.string :card_no
      t.string :name
      t.string :id_num
      t.string :body
      t.string :notify_url
      t.string :callback_url
      t.string :resp_code
      t.string :resp_desc
      t.string :mac
      t.datetime :finish_time
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
