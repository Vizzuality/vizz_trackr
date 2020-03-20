# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  name                   :string
#  team_id                :integer
#  role_id                :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  admin                  :boolean          default(FALSE)
#  rate_id                :bigint
#  dedication             :float            default(0.74), not null
#  active                 :boolean          default(TRUE)
#

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
