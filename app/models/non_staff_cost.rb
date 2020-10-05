# == Schema Information
#
# Table name: non_staff_costs
#
#  id                  :bigint           not null, primary key
#  cost                :float            not null
#  cost_type           :string           not null
#  details             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  contract_id         :bigint           not null
#  reporting_period_id :bigint           not null
#
# Indexes
#
#  index_non_staff_costs_on_contract_id          (contract_id)
#  index_non_staff_costs_on_reporting_period_id  (reporting_period_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#  fk_rails_...  (reporting_period_id => reporting_periods.id)
#

class NonStaffCost < ApplicationRecord
  TYPES = %w[outsource travel servers others].freeze
  enum type: array_to_enum_hash(TYPES)
  belongs_to :contract
  belongs_to :reporting_period
end
