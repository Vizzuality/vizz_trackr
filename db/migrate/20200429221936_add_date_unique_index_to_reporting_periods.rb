class AddDateUniqueIndexToReportingPeriods < ActiveRecord::Migration[6.0]
  def change
    add_index :reporting_periods, :date, unique: true
  end
end
