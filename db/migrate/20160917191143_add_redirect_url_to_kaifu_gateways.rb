class AddRedirectUrlToKaifuGateways < ActiveRecord::Migration[5.0]
  def change
    add_column :kaifu_gateways, :redirect_url, :string
  end
end
