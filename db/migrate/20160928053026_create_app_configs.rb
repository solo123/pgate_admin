class CreateAppConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :app_configs do |t|
      t.string :group
      t.string :name
      t.string :val

      t.timestamps
    end
  end
end
