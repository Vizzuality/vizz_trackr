class CreateFullReports < ActiveRecord::Migration[6.0]
  def change
    create_view :full_reports
  end
end
