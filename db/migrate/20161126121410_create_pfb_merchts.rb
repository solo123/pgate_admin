class CreatePfbMerchts < ActiveRecord::Migration[5.0]
  def change
    create_table :pfb_merchts do |t|
      t.belongs_to :merchant
      t.belongs_to :org
      t.string :mch_id
      t.string :mch_key
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
