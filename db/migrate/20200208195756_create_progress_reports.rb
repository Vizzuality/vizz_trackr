class CreateProgressReports < ActiveRecord::Migration[6.0]
  def change
    create_table :progress_reports do |t|
      t.references :reporting_period, null: false, foreign_key: true
      t.references :contract, null: false, foreign_key: true
      t.float :percentage
      t.float :delta

      t.timestamps
    end
  end
end
