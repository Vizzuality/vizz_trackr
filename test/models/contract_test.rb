# == Schema Information
#
# Table name: contracts
#
#  id            :bigint           not null, primary key
#  aasm_state    :string
#  alias         :string           default([]), is an Array
#  budget        :float
#  code          :string
#  contract_rate :float            default(175.0)
#  end_date      :date
#  name          :string
#  notes         :text
#  start_date    :date
#  summary       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  project_id    :bigint           not null
#
# Indexes
#
#  index_contracts_on_alias       (alias) USING gin
#  index_contracts_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#

require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  test '#linear_income is not calculated if no budget and dates in the contract' do
    contract = create(:contract, start_date: nil, end_date: nil, budget: nil)
    assert_nil contract.linear_income
  end

  test '#linear_income returns budget if contract start and end date in same month' do
    contract = create(:contract, start_date: '05/01/2019', end_date: '25/01/2019')
    assert_equal contract.budget, contract.linear_income
  end

  test '#linear_income returns budget / difference in months between start and end dates' do
    contract = create(:contract, start_date: '05/01/2019', end_date: '25/05/2019')
    assert_equal (contract.budget / 5), contract.linear_income
  end

  test '#linear_income returns budget - accrued / difference in months between start and end dates' do
    reporting_period1 = create(:reporting_period, date: 1.month.ago)
    contract = create(:contract, budget: 100, start_date: 2.months.ago, end_date: 1.month.from_now)
    create(:progress_report, percentage: 50, contract: contract,
                             reporting_period: reporting_period1)
    assert_equal 25, contract.linear_income
  end

  test '#linear_income returns returns remaining budget if last report is on the end_date' do
    reporting_period1 = create(:reporting_period, date: Time.zone.today)
    contract = create(:contract, budget: 100, start_date: 2.months.ago, end_date: Time.zone.today)
    create(:progress_report, percentage: 50, contract: contract,
                             reporting_period: reporting_period1)
    assert_equal 50, contract.linear_income
  end
end
