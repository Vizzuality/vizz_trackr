class RemoveAliasFromProjects < ActiveRecord::Migration[6.0]
  def change
    remove_column :projects, :alias, :string
  end
end
