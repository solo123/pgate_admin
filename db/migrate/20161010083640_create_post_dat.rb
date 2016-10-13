class CreatePostDat < ActiveRecord::Migration[5.0]
  def change
    create_table :post_dats do |t|
      t.references :sender, polymorphic: true, index: true
      t.string :url
      t.text :data
      t.text :response
      t.text :body
      t.text :error_message

      t.timestamps
    end
  end
end
