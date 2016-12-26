class CreateSubMcts < ActiveRecord::Migration[5.0]
  def change
    create_table :sub_mcts do |t|
      t.belongs_to :org
      t.belongs_to :bank_mct, polymorphic: true
      t.string :bank_name
      t.string :parent_mch_id
      t.string :mch_id
      t.integer :pay_channel_type, default: 0
      t.integer :clearing_type, default: 0
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
