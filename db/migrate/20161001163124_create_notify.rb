class CreateNotify < ActiveRecord::Migration[5.0]
  def change
    create_table :notifies do |t|
      t.references :sender, polymorphic: true, index: true
      t.string :data
      t.string :notify_url
      t.text :message
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
