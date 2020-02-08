class CreateBudgetLines < ActiveRecord::Migration[6.0]
  def change
    create_table :budget_lines do |t|
      t.references :contract, null: false, foreign_key: true
      t.references :role, foreign_key: true
      t.float :percentage
      t.string :details

      t.timestamps
    end
  end
end
