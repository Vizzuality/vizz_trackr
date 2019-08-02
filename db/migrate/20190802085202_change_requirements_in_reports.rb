class ChangeRequirementsInReports < ActiveRecord::Migration[6.0]
  def change
    change_column :reports, :role_id, :integer, null: true
    change_column :reports, :team_id, :integer, null: true
  end
end
