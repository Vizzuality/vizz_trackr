class AddBaseRateToReportingPeriod < ActiveRecord::Migration[6.0]
  def change
    add_column :reporting_periods, :base_rate, :integer, default: 175
  end
end
