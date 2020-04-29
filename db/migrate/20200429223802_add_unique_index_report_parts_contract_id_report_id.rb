class AddUniqueIndexReportPartsContractIdReportId < ActiveRecord::Migration[6.0]
  def change
    add_index :report_parts, [:contract_id, :report_id], unique: true
  end
end
