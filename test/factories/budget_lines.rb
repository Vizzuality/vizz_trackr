# == Schema Information
#
# Table name: budget_lines
#
#  id          :bigint           not null, primary key
#  contract_id :bigint           not null
#  role_id     :bigint
#  percentage  :float
#  details     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  days        :integer
#

FactoryBot.define do
  factory :budget_line do
    contract { nil }
    role { nil }
    percentage { 1.5 }
    details { 'MyString' }
  end
end
