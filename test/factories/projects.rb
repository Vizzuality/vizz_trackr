# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  is_billable :boolean          default(TRUE)
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :bigint
#
# Indexes
#
#  index_projects_on_name     (name) UNIQUE
#  index_projects_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#

FactoryBot.define do
  factory :project do
    sequence(:name) { |n| 'Project of great importance -' + ('AA'..'ZZ').to_a[n] }
    is_billable { true }
  end
end
