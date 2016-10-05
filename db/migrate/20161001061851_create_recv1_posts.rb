class CreateRecv1Posts < ActiveRecord::Migration[5.0]
  def change
    create_table :recv1_posts do |t|
      t.string :method
      t.string :remote_host
      t.string :header
      t.string :params
      t.text :detail
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
