class CreateBizLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :biz_logs do |t|
      t.string :op_name
      t.text :op_message
      t.text :op_result
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
