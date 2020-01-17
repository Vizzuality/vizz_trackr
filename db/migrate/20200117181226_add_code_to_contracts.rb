class AddCodeToContracts < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :code, :string
  end
end
