class AddDetailsToNonStaffCosts < ActiveRecord::Migration[6.0]
  def change
    add_column :non_staff_costs, :details, :string
  end
end
