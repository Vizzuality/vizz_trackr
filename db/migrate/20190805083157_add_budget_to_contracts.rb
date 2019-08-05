class AddBudgetToContracts < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :budget, :float
  end
end
