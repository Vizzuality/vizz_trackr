class EditProgressReportsReportingPeriodIndex < ActiveRecord::Migration[6.0]
  def change
    remove_index :progress_reports, :reporting_period_id
  end
end
