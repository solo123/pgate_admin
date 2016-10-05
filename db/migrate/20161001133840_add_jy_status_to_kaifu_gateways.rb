class AddJyStatusToKaifuGateways < ActiveRecord::Migration[5.0]
  def change
    add_column :kaifu_gateways, :pay_code, :string
    add_column :kaifu_gateways, :pay_desc, :string
    add_column :kaifu_gateways, :t0_code, :string
    add_column :kaifu_gateways, :t0_desc, :string
  end
end
