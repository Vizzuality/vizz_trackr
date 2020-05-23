class RemoveRoleIdFromReports < ActiveRecord::Migration[6.0]
  def change
    remove_reference :reports, :role, null: false, foreign_key: true
  end
end
