class AddPayStateToPayResults < ActiveRecord::Migration[5.0]
  def change
    add_column :pay_results, :pay_state, :string
  end
end
