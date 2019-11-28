class AddAasmStateToReportingPeriods < ActiveRecord::Migration[6.0]
  def change
    add_column :reporting_periods, :aasm_state, :string
  end
end
