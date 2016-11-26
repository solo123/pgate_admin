class CreateMerchants < ActiveRecord::Migration[5.0]
  def change
    create_table :merchants do |t|
      t.belongs_to :org
      t.string :full_name
      t.string :short_name
      t.string :service_tel
      t.string :business_category
      t.text :memo
      t.string :lic_number
      t.string :jp_name
      t.string :jp_id_number
      t.string :contact_name
      t.string :contact_tel
      t.string :contact_email
      t.string :province
      t.string :urbn
      t.string :city_area
      t.text :address
    end
  end
end
