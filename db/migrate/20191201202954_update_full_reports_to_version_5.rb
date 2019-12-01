class UpdateFullReportsToVersion5 < ActiveRecord::Migration[6.0]
  def change
    update_view :full_reports, version: 5, revert_to_version: 4
  end
end
