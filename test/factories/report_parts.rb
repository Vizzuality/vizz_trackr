# == Schema Information
#
# Table name: report_parts
#
#  id          :bigint           not null, primary key
#  cost        :float
#  days        :float
#  percentage  :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  contract_id :bigint           not null
#  report_id   :bigint           not null
#  role_id     :bigint
#
# Indexes
#
#  index_report_parts_on_contract_id                            (contract_id)
#  index_report_parts_on_contract_id_and_report_id_and_role_id  (contract_id,report_id,role_id) UNIQUE
#  index_report_parts_on_report_id                              (report_id)
#  index_report_parts_on_role_id                                (role_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#  fk_rails_...  (report_id => reports.id)
#  fk_rails_...  (role_id => roles.id)
#

FactoryBot.define do
  factory :report_part do
    association :report
    association :contract
    association :role
    percentage { 1.5 }
    days { 1 }
    cost { 100 }
  end
end
