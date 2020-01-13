FactoryBot.define do
  factory :rate do
    sequence(:code) { |n| 'Ninja -' + ('AA'..'ZZ').to_a[n] }
    value { 1.5 }
  end
end
