class ChangeDaysToFloat < ActiveRecord::Migration[6.0]
  def change
    change_column :report_parts, :days, :float
  end
end
