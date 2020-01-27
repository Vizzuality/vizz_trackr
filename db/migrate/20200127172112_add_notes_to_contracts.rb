class AddNotesToContracts < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :notes, :text
  end
end
