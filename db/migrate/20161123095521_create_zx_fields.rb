class CreateZxFields < ActiveRecord::Migration[5.0]
  def change
    create_table :zx_fields do |t|
      t.string :trancode
      t.integer :msg_typ
      t.string :regn_en_nm
      t.string :regn_cn_nm
      t.integer :sort_num
      t.string :regn_data_typ
      t.integer :regn_nt_null
      t.integer :is_sign_regn
      t.integer :actv_stat
      t.string :table_name
      t.string :field_name
      t.timestamp
    end
  end
end
