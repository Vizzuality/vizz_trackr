FactoryBot.define do
  factory :user do
    sequence(:name) { |n| 'Anthony -' + ('AA'..'ZZ').to_a[n] }
    association :team
    association :role
    sequence(:email) { |n| "anthony#{('AA'..'ZZ').to_a[n]}@example.com" }
    password { 'secret' }
  end

  factory :admin, class: 'User' do
    sequence(:name) { |n| 'Admin -' + ('AA'..'ZZ').to_a[n] }
    association :team
    association :role
    sequence(:email) { |n| "admin#{('AA'..'ZZ').to_a[n]}@example.com" }
    admin { true }
    password { 'secret' }
  end
end
