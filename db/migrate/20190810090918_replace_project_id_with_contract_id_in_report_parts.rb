class ReplaceProjectIdWithContractIdInReportParts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :report_parts, :project
    add_reference :report_parts, :contract, index: true, foreign_key: true,
      null: false
  end
end
