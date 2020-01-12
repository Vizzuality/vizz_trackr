FactoryBot.define do
  factory :role do
    sequence(:name) { |n| 'Designer -' + ('AA'..'ZZ').to_a[n] }
  end
end
