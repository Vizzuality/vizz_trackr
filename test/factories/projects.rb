FactoryBot.define do
  factory :project do
    sequence(:name) { |n| 'Project of great importance -' + ('AA'..'ZZ').to_a[n] }
    is_billable { true }
  end
end
