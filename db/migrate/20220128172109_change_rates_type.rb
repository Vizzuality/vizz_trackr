class ChangeRatesType < ActiveRecord::Migration[6.0]
  def change
    change_column :reporting_periods, :base_rate, :float
    change_column :contracts, :contract_rate, :float
  end
end
