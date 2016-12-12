class CreateChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :channels do |t|
      t.string :channel_code
      t.string :channel_name
      t.string :success_code
      t.string :channel_out_code
      t.string :biz_out_code
      t.string :biz_type
      t.integer :t1_rate
      t.integer :d0_add_rate
      t.integer :d0_min_fee
      t.string :prepay_url
      t.string :query_url
      t.string :withdraw_url
      t.string :clr_url
      t.string :tmk
      t.string :public_cert
      t.string :channel_public_cert
      t.string :aes_key
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
