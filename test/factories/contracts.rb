FactoryBot.define do
  factory :contract do
    sequence(:name) { |n| 'Contract something -' + ('AA'..'ZZ').to_a[n] }
    association :project
    budget { 100_000.00 }
    start_date { 2.month.ago }
    end_date { 1.month.ago }
  end
end
