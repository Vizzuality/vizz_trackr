class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.date :due_date
      t.date :extended_date
      t.text :milestone
      t.date :invoiced_on
      t.belongs_to :contract, index: true, foreign_key: true
      t.text :observations
    end
  end
end
