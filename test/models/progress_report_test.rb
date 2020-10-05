# == Schema Information
#
# Table name: progress_reports
#
#  id                  :bigint           not null, primary key
#  delta               :float
#  percentage          :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  contract_id         :bigint           not null
#  reporting_period_id :bigint           not null
#
# Indexes
#
#  index_progress_reports_on_contract_id                          (contract_id)
#  index_progress_reports_on_reporting_period_id_and_contract_id  (reporting_period_id,contract_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#  fk_rails_...  (reporting_period_id => reporting_periods.id)
#

require 'test_helper'

class ProgressReportTest < ActiveSupport::TestCase
  test '#calculate_delta makes delta like percentage when adding the first report' do
    progress_report = create(:progress_report, percentage: 25)
    assert_equal 25, progress_report.delta
  end

  test '#calculate_delta saves difference when creating a progress report after an existing one' do
    contract = create(:contract)
    reporting_period1 = create(:reporting_period, date: 3.months.ago)
    reporting_period2 = create(:reporting_period, date: 2.months.ago)
    reporting_period3 = create(:reporting_period, date: 1.month.ago)
    create(:progress_report, percentage: 25, contract: contract,
                             reporting_period: reporting_period1)
    create(:progress_report, percentage: 35, contract: contract,
                             reporting_period: reporting_period2)
    progress_report = create(:progress_report, percentage: 55, contract: contract,
                                               reporting_period: reporting_period3)
    assert_equal 20, progress_report.delta
  end

  test '#calculate_delta updates existing progress report when adding a new report in the past' do
    contract = create(:contract)
    reporting_period1 = create(:reporting_period, date: 3.months.ago)
    reporting_period2 = create(:reporting_period, date: 2.months.ago)
    reporting_period3 = create(:reporting_period, date: 1.month.ago)
    should_update_this = create(:progress_report, percentage: 50, contract: contract,
                                                  reporting_period: reporting_period2)
    create(:progress_report, percentage: 60, contract: contract,
                             reporting_period: reporting_period3)
    progress_report = create(:progress_report, percentage: 30, contract: contract,
                                               reporting_period: reporting_period1)
    assert_equal 30, progress_report.delta
    assert_equal 20, should_update_this.reload.delta
  end

  test '#calculate_delta should be zero if no progress' do
    contract = create(:contract)
    reporting_period1 = create(:reporting_period, date: 3.months.ago)
    reporting_period2 = create(:reporting_period, date: 2.months.ago)
    create(:progress_report, percentage: 50, contract: contract,
                             reporting_period: reporting_period1)
    progress_report = create(:progress_report, percentage: 50, contract: contract,
                                               reporting_period: reporting_period2)
    assert_equal 0, progress_report.delta
  end
end
