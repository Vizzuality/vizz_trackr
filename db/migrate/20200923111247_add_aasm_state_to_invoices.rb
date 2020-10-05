class AddAasmStateToInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :aasm_state, :string
  end
end
