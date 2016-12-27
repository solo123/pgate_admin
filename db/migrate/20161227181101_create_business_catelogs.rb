class CreateBusinessCatelogs < ActiveRecord::Migration[5.0]
  def change
    create_table :business_catelogs do |t|
      t.string :channel_name
      t.string :business_name
      t.string :v1
      t.string :v2
      t.string :v3
      t.string :v4
      t.timestamps
    end
  end
end
