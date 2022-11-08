# == Schema Information
#
# Table name: budget_lines
#
#  id            :bigint           not null, primary key
#  adjusted_days :float
#  days          :integer
#  details       :string
#  percentage    :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  contract_id   :bigint           not null
#  role_id       :bigint
#
# Indexes
#
#  index_budget_lines_on_contract_id  (contract_id)
#  index_budget_lines_on_role_id      (role_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#  fk_rails_...  (role_id => roles.id)
#

FactoryBot.define do
  factory :budget_line do
    contract { nil }
    role { nil }
    percentage { 1.5 }
    details { "MyString" }
  end
end
