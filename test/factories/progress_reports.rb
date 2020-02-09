# == Schema Information
#
# Table name: progress_reports
#
#  id                  :bigint           not null, primary key
#  reporting_period_id :bigint           not null
#  contract_id         :bigint           not null
#  percentage          :float
#  delta               :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryBot.define do
  factory :progress_report do
    reporting_period { nil }
    contract { nil }
    percentage { 1.5 }
    delta { 1.5 }
  end
end
