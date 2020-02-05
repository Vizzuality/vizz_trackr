class AddSummaryToContracts < ActiveRecord::Migration[6.0]
  def change
    add_column :contracts, :summary, :text
  end
end
