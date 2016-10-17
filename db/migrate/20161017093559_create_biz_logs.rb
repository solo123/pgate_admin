class CreateBizLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :biz_logs do |t|
      t.string :op_name
      t.string :op_message
      t.string :op_result
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
