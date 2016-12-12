class CreateZxClrs < ActiveRecord::Migration[5.0]
  def change
    create_table :zx_clrs do |t|
      t.string :chnl_id
      t.string :pay_chnl_encd
      t.string :clr_dt
      t.string :trancode
      t.string :clr_dtl_fn
      t.string :dtl_memo
      t.string :rtncode
      t.string :rtninfo
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
