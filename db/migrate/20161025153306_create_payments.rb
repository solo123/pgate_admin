class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :req_recvs do |t|
      t.string :remote_ip
      t.string :method
      t.string :org_code
      t.string :sign
      t.text :data
      t.text :params
      t.datetime :time_recv
      t.text :resp_body

      t.timestamps
    end

    create_table :payments do |t|
      t.belongs_to :req_recv, index: true
      t.string :app_id
      t.string :open_id
      t.belongs_to :org, index: true
      t.string :order_num, index: true
      t.string :order_day, index: true
      t.string :order_time
      t.string :order_expire_time
      t.string :goods_tag
      t.string :product_id
      t.string :order_title
      t.string :attach_info
      t.integer :amount
      t.integer :fee
      t.string :limit_pay
      t.string :remote_ip
      t.string :terminal_num
      t.string :method
      t.string :callback_url
      t.string :notify_url
      t.belongs_to :card, index: true
      t.integer :status, default: 0
      t.timestamps
    end

    create_table :orgs do |t|
      t.string :name
      t.string :org_code
      t.string :tmk
      t.integer :d0_rate
      t.integer :d0_min_fee
      t.integer :t1_rate
      t.integer :status, default: 0
      t.timestamps
    end

    create_table :cards do |t|
      t.string :card_num
      t.string :holder_name
      t.string :person_id_num
      t.timestamps
    end

    create_table :pay_results do |t|
      t.belongs_to :payment, index: true
      t.string :channel_name
      t.string :uni_order_num
      t.string :channel_order_num
      t.string :real_order_num
      t.string :send_code
      t.string :send_desc
      t.datetime :send_time
      t.string :pay_code
      t.string :pay_desc
      t.datetime :pay_time
      t.string :t0_code
      t.string :t0_desc
      t.string :pay_url
      t.string :barcode_url
      t.timestamps
    end

  end
end
