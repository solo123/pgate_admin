class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :org_id, unique: true
      t.string :tmk
      t.integer :d0_min_fee
      t.integer :d0_min_percent
      t.integer :status

      t.timestamps
    end
  end
end
