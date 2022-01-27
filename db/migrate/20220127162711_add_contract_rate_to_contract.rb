class AddContractRateToContract < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :contract_rate, :integer, default: 175
  end
end
