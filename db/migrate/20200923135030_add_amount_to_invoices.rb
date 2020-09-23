class AddAmountToInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :amount, :float
  end
end
