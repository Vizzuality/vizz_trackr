class RemovePercentCompleteFromContracts < ActiveRecord::Migration[6.0]
  def change
    remove_column :contracts, :percent_complete, :float
  end
end
