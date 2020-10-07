class AddCurrencyToInvoices < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :currency, :string, default: 'dollar'
  end
end
