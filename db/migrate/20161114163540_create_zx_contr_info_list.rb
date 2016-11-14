class CreateZxContrInfoList < ActiveRecord::Migration[5.0]
  def change
    create_table :zx_contr_info_lists do |t|
      t.belongs_to :zx_mercht, index: true
      t.string :pay_typ_encd
      t.string :start_dt
      t.decimal :pay_typ_fee_rate, precision: 5, scale: 4

      t.timestamps
    end
  end
end
