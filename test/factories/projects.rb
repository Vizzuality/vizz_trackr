# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :bigint
#  is_billable :boolean          default(TRUE)
#

FactoryBot.define do
  factory :project do
    sequence(:name) { |n| 'Project of great importance -' + ('AA'..'ZZ').to_a[n] }
    is_billable { true }
  end
end
