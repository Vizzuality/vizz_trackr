class RenameRolesIdToRoleId < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :roles_id, :role_id
  end
end
