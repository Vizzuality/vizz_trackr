class AddIndexToNameOnRoles < ActiveRecord::Migration[6.0]
  def change
    add_index :roles, :name, unique: true
  end
end
