class AddAdjustedDaysToBudgetLines < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_lines, :adjusted_days, :float
  end
end
