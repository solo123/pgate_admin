class AddDataToRecvPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :recv_posts, :data, :string
    add_column :recv_posts, :message, :string
  end
end
