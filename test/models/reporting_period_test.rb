# == Schema Information
#
# Table name: reporting_periods
#
#  id         :bigint           not null, primary key
#  aasm_state :string
#  base_rate  :integer          default(175)
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reporting_periods_on_date  (date) UNIQUE
#

require 'test_helper'

class ReportingPeriodTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
