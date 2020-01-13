# == Schema Information
#
# Table name: contracts
#
#  id         :bigint           not null, primary key
#  name       :string
#  project_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  budget     :float
#  alias      :string           default([]), is an Array
#  start_date :date
#  end_date   :date
#  aasm_state :string
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
end
