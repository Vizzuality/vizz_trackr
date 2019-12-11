class UpdateMonthlyIncomesToVersion2 < ActiveRecord::Migration[6.0]
  def change
    update_view :monthly_incomes, version: 2, revert_to_version: 1
  end
end
