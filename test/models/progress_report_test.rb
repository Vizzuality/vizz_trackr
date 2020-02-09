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

require 'test_helper'

class ProgressReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
