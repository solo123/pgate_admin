class CreateKaifuResult < ActiveRecord::Migration[5.0]
  def change
    create_table :kaifu_results do |t|
      t.belongs_to :recv_post
      t.belongs_to :client
      t.belongs_to :client_payment
      t.string :send_time
      t.string :send_seq_id
      t.string :organization_id
      t.string :org_send_seq_id
      t.integer :trans_amt
      t.integer :fee
      t.string :pay_result
      t.string :pay_desc
      t.string :t0_resp_code
      t.string :t0_resp_desc
      t.string :resp_code
      t.string :resp_desc
      t.string :mac
      t.string :notify_url
      t.integer :notify_status, default: 0
      t.datetime :notify_time
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
