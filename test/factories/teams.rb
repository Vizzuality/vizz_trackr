FactoryBot.define do
  factory :team do
    sequence(:name) { |n| 'Team -' + ('AA'..'ZZ').to_a[n] }
  end
end
