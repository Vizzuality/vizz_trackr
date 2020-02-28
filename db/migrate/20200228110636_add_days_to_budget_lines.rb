class AddDaysToBudgetLines < ActiveRecord::Migration[6.0]
  def change
    add_column :budget_lines, :days, :integer
  end
end
