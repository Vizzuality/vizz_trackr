class UpdateReportPartsUniquenessIndex < ActiveRecord::Migration[6.0]
  def change
    remove_index :report_parts, name: :index_report_parts_on_contract_id_and_report_id
    add_index :report_parts, [:contract_id, :report_id, :role_id], unique: true
  end
end
