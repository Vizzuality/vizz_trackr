FactoryBot.define do
  factory :reporting_period do
    sequence(:date) { |n| n.months.ago }
  end
end
