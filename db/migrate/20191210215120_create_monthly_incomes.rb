class CreateMonthlyIncomes < ActiveRecord::Migration[6.0]
  def change
    create_view :monthly_incomes
  end
end
