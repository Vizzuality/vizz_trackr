class AddEstimatedToReports < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :estimated, :boolean, default: false
  end
end
