class CreateKaifuQuery < ActiveRecord::Migration[5.0]
  def change
    create_table :kaifu_queries do |t|
      t.belongs_to :payment_query, index: true
      t.string :send_time
      t.string :send_seq_id
      t.string :trans_type
      t.string :organization_id
      t.string :org_send_seq_id
      t.string :trans_time
      t.string :pay_result
      t.string :pay_desc
      t.string :t0_pay_result
      t.string :t0_pay_desc
      t.string :resp_code
      t.string :resp_desc
      t.string :mac
      t.text :response_text
      t.timestamps
    end
  end
end
