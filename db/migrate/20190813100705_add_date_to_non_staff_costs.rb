class AddDateToNonStaffCosts < ActiveRecord::Migration[6.0]
  def change
    add_column :non_staff_costs, :date, :date, null: false
  end
end
