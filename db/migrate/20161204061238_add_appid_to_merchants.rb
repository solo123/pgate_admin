class AddAppidToMerchants < ActiveRecord::Migration[5.0]
  def change
    change_table :merchants do |t|
      t.string :channel_code
      t.string :app_id
      t.string :merchant_type
    end
  end
end
