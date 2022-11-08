class AddAliasToContracts < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :alias, :string, array: true, default: []
    add_index :contracts, :alias, using: "gin"
  end
end
