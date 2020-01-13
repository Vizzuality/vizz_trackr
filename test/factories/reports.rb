FactoryBot.define do
  factory :report do
    association :user
    association :team
    association :role
    association :reporting_period
  end
end
