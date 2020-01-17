# == Schema Information
#
# Table name: report_parts
#
#  id          :bigint           not null, primary key
#  report_id   :bigint           not null
#  percentage  :float
#  days        :float
#  cost        :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  contract_id :bigint           not null
#

FactoryBot.define do
  factory :report_part do
    association :report
    association :contract
    percentage { 1.5 }
    days { 1 }
    cost { 100 }
  end
end
