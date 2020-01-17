# == Schema Information
#
# Table name: non_staff_costs
#
#  id                  :bigint           not null, primary key
#  cost                :float            not null
#  contract_id         :bigint           not null
#  cost_type           :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  reporting_period_id :bigint           not null
#  details             :string
#

require 'test_helper'

class NonStaffCostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
