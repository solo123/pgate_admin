class CreatePostData < ActiveRecord::Migration[5.0]
  def change
    create_table :post_data do |t|
      t.references :sender, polymorphic: true, index: true
      t.string :url
      t.string :data
      t.string :response
      t.string :body
      t.text :error_message
      
      t.timestamps
    end
  end
end
