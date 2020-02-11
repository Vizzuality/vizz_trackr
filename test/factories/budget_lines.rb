FactoryBot.define do
  factory :budget_line do
    contract { nil }
    role { nil }
    percentage { 1.5 }
    details { "MyString" }
  end
end
