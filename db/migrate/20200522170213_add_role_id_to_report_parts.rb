class AddRoleIdToReportParts < ActiveRecord::Migration[6.0]
  def change
    add_reference :report_parts, :role, null: true, foreign_key: true

    ReportPart.all.find_each do |rp|
      rp.role_id = rp.report.role_id
      rp.save
    end
  end
end
