class CreateKaifuSignins < ActiveRecord::Migration
  def change
    create_table :kaifu_signins do |t|
      t.string :send_time
      t.string :send_seq_id
      t.string :trans_type
      t.string :organization_id
      t.string :terminal_info
      t.string :resp_code
      t.string :resp_desc
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
