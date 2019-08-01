class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.references :reporting_period, null: false, foreign_key: true

      t.timestamps
    end
  end
end
