class CreateNonStaffCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :non_staff_costs do |t|
      t.float :cost, null: false
      t.references :contract, null: false, foreign_key: true
      t.string :cost_type, null: false

      t.timestamps
    end
  end
end
