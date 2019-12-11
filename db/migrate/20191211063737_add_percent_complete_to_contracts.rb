class AddPercentCompleteToContracts < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :percent_complete, :float
  end
end
