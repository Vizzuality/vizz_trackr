FactoryBot.define do
  factory :progress_report do
    reporting_period { nil }
    contract { nil }
    percentage { 1.5 }
    delta { 1.5 }
  end
end
