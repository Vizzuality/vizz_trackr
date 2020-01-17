# == Schema Information
#
# Table name: teams
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :team do
    sequence(:name) { |n| 'Team -' + ('AA'..'ZZ').to_a[n] }
  end
end
