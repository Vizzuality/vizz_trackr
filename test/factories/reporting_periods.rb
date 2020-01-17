# == Schema Information
#
# Table name: reporting_periods
#
#  id         :bigint           not null, primary key
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  aasm_state :string
#

FactoryBot.define do
  factory :reporting_period do
    sequence(:date) { |n| n.months.ago }
  end
end
