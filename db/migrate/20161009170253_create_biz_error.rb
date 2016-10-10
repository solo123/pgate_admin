class CreateBizError < ActiveRecord::Migration[5.0]
  def change
    create_table :biz_errors do |t|
      t.references :error_source, polymorphic: true, index: true
      t.string :code
      t.string :message
      t.text :detail

      t.timestamps
    end
  end
end
