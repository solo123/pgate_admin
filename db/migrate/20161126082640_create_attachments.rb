class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.belongs_to :attach_owner, polymorphic: true, index: true
      t.string :tag_name
      t.string :title
      t.string :attach_asset
      t.timestamps
    end
  end
end
