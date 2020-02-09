# == Schema Information
#
# Table name: contracts
#
#  id               :bigint           not null, primary key
#  name             :string
#  project_id       :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  budget           :float
#  alias            :string           default([]), is an Array
#  start_date       :date
#  end_date         :date
#  aasm_state       :string
#  percent_complete :float
#  code             :string
#  notes            :text
#  summary          :text
#

FactoryBot.define do
  factory :contract do
    sequence(:name) { |n| 'Contract something -' + ('AA'..'ZZ').to_a[n] }
    sequence(:code) { |n| 'Code-' + ('AA'..'ZZ').to_a[n] }
    association :project
    budget { 100_000.00 }
    start_date { 2.month.ago }
    end_date { 1.month.ago }
  end
end
