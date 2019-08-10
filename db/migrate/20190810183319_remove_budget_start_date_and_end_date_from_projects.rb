class RemoveBudgetStartDateAndEndDateFromProjects < ActiveRecord::Migration[6.0]
  def change
    remove_column :projects, :budget, :float
    remove_column :projects, :start_date, :date
    remove_column :projects, :end_date, :date
  end
end
