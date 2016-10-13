class CreateRecvPosts < ActiveRecord::Migration
  def change
    create_table :recv_posts do |t|
      t.string :method
      t.string :remote_host
      t.text :header
      t.text :params
      t.text :detail
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
