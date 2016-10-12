class CreateTfbOrder < ActiveRecord::Migration[5.0]
  def change
    create_table :tfb_orders do |t|
      t.belongs_to :client_payment, index: true

      t.string :sign_type
      t.string :ver
      t.string :input_charset
      t.string :sign
      t.integer :sign_key_index

      t.string :spid
      t.string :notify_url
      t.string :pay_show_url
      t.string :sp_billno
      t.string :spbill_create_ip
      t.string :pay_type
      t.string :tran_time
      t.integer :tran_amt
      t.string :cur_type
      t.string :pay_limit
      t.string :auth_code
      t.string :item_name
      t.string :item_attach
      t.string :attach
      t.string :sp_udid
      t.string :bank_mch_name
      t.string :bank_mch_id

      t.string :retcode
      t.string :retmsg
      t.string :listid
      t.string :qrcode
      t.string :pay_info
      t.string :sysd_time

      t.integer :status, default: 0
      t.timestamps
    end
  end
end
