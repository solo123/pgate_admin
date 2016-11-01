class CreateSentPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :sent_posts do |t|
      t.belongs_to :sender, polymorphic: true, index: true
      t.string :method
      t.string :post_url
      t.text :post_data
      t.string :resp_type
      t.text :resp_body
      t.text :result_message

      t.timestamps
    end
    create_table :http_logs do |t|
      t.belongs_to :sender, polymorphic: true, index: true
      t.string :method
      t.string :sender
      t.string :receiver
      t.text :remote_detail
      t.text :send_data
      t.text :resp_body
      t.timestamps
    end
  end
end
