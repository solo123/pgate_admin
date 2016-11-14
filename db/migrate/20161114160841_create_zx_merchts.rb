class CreateZxMerchts < ActiveRecord::Migration[5.0]
  def change
    create_table :zx_merchts do |t|
      t.string :chnl_id
      t.string :chnl_mercht_id
      t.string :pay_chnl_encd
      t.string :mercht_belg_chnl_id
      t.string :mercht_full_name
      t.string :mercht_sht_nm
      t.string :cust_serv_tel
      t.string :contcr_nm
      t.string :contcr_tel
      t.string :contcr_mobl_num
      t.string :contcr_eml
      t.string :opr_cls
      t.string :mercht_memo
      t.string :prov
      t.string :urbn
      t.text :dtl_addr
      t.string :acct_nm
      t.string :opn_bnk
      t.string :is_nt_citic
      t.string :acct_typ
      t.string :pay_ibank_num
      t.string :acct_num
      t.string :is_nt_two_line
      t.string :comm_fee_acct_type
      t.string :comm_fee_acct_nm
      t.string :comm_fee_bank_nm
      t.string :ibank_num
      t.string :comm_fee_acct_num
      t.string :biz_lics_asset
      t.string :dtl_memo

      t.string :appl_typ
      t.string :trancode
      t.text :msg_sign

      t.integer :status, default: 0

      t.timestamps
    end
  end
end
