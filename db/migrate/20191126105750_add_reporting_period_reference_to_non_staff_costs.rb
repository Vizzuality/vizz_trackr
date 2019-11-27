class AddReportingPeriodReferenceToNonStaffCosts < ActiveRecord::Migration[6.0]
  def change
    add_reference :non_staff_costs, :reporting_period, null: false, foreign_key: true
    remove_column :non_staff_costs, :date
  end
end
