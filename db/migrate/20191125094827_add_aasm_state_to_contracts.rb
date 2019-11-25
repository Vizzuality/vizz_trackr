class AddAasmStateToContracts < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :aasm_state, :string
  end
end
