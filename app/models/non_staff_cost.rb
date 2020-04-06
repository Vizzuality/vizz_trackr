# == Schema Information
#
# Table name: non_staff_costs
#
#  id                  :bigint           not null, primary key
#  cost                :float            not null
#  contract_id         :bigint           not null
#  cost_type           :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  reporting_period_id :bigint           not null
#  details             :string
#

class NonStaffCost < ApplicationRecord
  TYPES = %w[outsource travel servers others].freeze
  enum type: array_to_enum_hash(TYPES)
  belongs_to :contract
  belongs_to :reporting_period
end
