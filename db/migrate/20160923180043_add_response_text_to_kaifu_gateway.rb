class AddResponseTextToKaifuGateway < ActiveRecord::Migration[5.0]
  def change
    add_column :kaifu_gateways, :response_text, :string
  end
end
