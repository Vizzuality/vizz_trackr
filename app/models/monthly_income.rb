# == Schema Information
#
# Table name: monthly_incomes
#
#  income              :float
#  month               :date
#  aasm_state          :string
#  contract_id         :bigint
#  reporting_period_id :bigint
#

class MonthlyIncome < ActiveRecord::Base
  belongs_to :contract
  # this isn't strictly necessary, but it will prevent
  # rails from calling save, which would fail anyway.
  def readonly?
    true
  end
end
