# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_roles_on_name  (name) UNIQUE
#

FactoryBot.define do
  factory :role do
    sequence(:name) { |n| 'Designer -' + ('AA'..'ZZ').to_a[n] }
  end
end
