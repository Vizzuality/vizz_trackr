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

FactoryBot.define do
  factory :non_staff_cost do
    cost { 1.5 }
    association :contract
    association :reporting_period
    cost_type { NonStaffCost::TYPES.sample }
  end
end
