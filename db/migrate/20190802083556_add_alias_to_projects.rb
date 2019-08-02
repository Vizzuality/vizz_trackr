class AddAliasToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :alias, :string
  end
end
