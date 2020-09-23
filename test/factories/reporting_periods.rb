# == Schema Information
#
# Table name: reporting_periods
#
#  id         :bigint           not null, primary key
#  aasm_state :string
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reporting_periods_on_date  (date) UNIQUE
#

FactoryBot.define do
  factory :reporting_period do
    sequence(:date) { |n| n.months.ago }
  end
end
