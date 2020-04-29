class AddUniqueIndexForReportingPeriodsAndContractsOnProgressReport < ActiveRecord::Migration[6.0]
  def change
    add_index :progress_reports, [:reporting_period_id, :contract_id], unique: true
  end
end
