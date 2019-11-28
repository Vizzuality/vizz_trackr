# == Schema Information
#
# Table name: reports
#
#  id                  :bigint           not null, primary key
#  user_id             :bigint           not null
#  team_id             :integer
#  role_id             :integer
#  reporting_period_id :bigint           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  estimated           :boolean          default(FALSE)
#

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
