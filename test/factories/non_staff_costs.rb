FactoryBot.define do
  factory :non_staff_cost do
    cost { 1.5 }
    association :contract
    association :reporting_period
    cost_type { NonStaffCost::TYPES.sample }
  end
end
