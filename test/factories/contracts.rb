# == Schema Information
#
# Table name: contracts
#
#  id            :bigint           not null, primary key
#  aasm_state    :string
#  alias         :string           default([]), is an Array
#  budget        :float
#  code          :string
#  contract_rate :float            default(175.0)
#  end_date      :date
#  name          :string
#  notes         :text
#  start_date    :date
#  summary       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  project_id    :bigint           not null
#
# Indexes
#
#  index_contracts_on_alias       (alias) USING gin
#  index_contracts_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#

FactoryBot.define do
  factory :contract do
    sequence(:name) { |n| "Contract something -" + ("AA".."ZZ").to_a[n] }
    sequence(:code) { |n| "Code-" + ("AA".."ZZ").to_a[n] }
    association :project
    budget { 100_000.00 }
    start_date { 2.months.ago }
    end_date { 1.month.ago }
  end
end
