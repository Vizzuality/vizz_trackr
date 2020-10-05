# == Schema Information
#
# Table name: progress_reports
#
#  id                  :bigint           not null, primary key
#  delta               :float
#  percentage          :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  contract_id         :bigint           not null
#  reporting_period_id :bigint           not null
#
# Indexes
#
#  index_progress_reports_on_contract_id                          (contract_id)
#  index_progress_reports_on_reporting_period_id_and_contract_id  (reporting_period_id,contract_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#  fk_rails_...  (reporting_period_id => reporting_periods.id)
#

FactoryBot.define do
  factory :progress_report do
    association :reporting_period
    association :contract
    percentage { 25 }
    delta { 25 }
  end
end
