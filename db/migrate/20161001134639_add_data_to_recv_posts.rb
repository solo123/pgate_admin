class AddDataToRecvPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :recv_posts, :data, :text
    add_column :recv_posts, :message, :text
  end
end
