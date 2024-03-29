# == Schema Information
#
# Table name: rates
#
#  id         :bigint           not null, primary key
#  code       :string
#  value      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rates_on_code  (code) UNIQUE
#

FactoryBot.define do
  factory :rate do
    sequence(:code) { |n| "Ninja -" + ("AA".."ZZ").to_a[n] }
    value { 1.5 }
  end
end
