class LoosenValidationsForUsersRelations < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :role_id, :integer, null: true
    change_column :users, :team_id, :integer, null: true
  end
end
