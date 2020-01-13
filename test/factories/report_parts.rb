FactoryBot.define do
  factory :report_part do
    association :report
    association :contract
    percentage { 1.5 }
    days { 1 }
    cost { 100 }
  end
end
