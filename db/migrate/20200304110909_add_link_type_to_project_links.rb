class AddLinkTypeToProjectLinks < ActiveRecord::Migration[6.0]
  def change
    add_column :project_links, :link_type, :string
  end
end
