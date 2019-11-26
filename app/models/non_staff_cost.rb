class NonStaffCost < ApplicationRecord
  TYPES = %w[outsource travel servers].freeze
  enum type: array_to_enum_hash(TYPES)
  belongs_to :contract
  belongs_to :reporting_period
end
