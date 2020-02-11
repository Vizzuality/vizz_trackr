# == Schema Information
#
# Table name: budget_lines
#
#  id          :bigint           not null, primary key
#  contract_id :bigint           not null
#  role_id     :bigint
#  percentage  :float
#  details     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class BudgetLineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
