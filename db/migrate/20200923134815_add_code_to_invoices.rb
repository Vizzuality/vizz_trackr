class AddCodeToInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :code, :string
  end
end
