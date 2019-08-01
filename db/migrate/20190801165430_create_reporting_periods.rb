class CreateReportingPeriods < ActiveRecord::Migration[6.0]
  def change
    create_table :reporting_periods do |t|
      t.date :date

      t.timestamps
    end
  end
end
