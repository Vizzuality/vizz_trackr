class CreateReportParts < ActiveRecord::Migration[6.0]
  def change
    create_table :report_parts do |t|
      t.references :report, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.float :percentage
      t.integer :days
      t.float :cost

      t.timestamps
    end
  end
end
