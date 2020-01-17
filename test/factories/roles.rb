# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :role do
    sequence(:name) { |n| 'Designer -' + ('AA'..'ZZ').to_a[n] }
  end
end
