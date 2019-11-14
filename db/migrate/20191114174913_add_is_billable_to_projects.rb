class AddIsBillableToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :is_billable, :boolean, default: true
  end
end
