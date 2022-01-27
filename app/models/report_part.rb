# == Schema Information
#
# Table name: report_parts
#
#  id          :bigint           not null, primary key
#  cost        :float
#  days        :float
#  percentage  :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  contract_id :bigint           not null
#  report_id   :bigint           not null
#  role_id     :bigint
#
# Indexes
#
#  index_report_parts_on_contract_id                            (contract_id)
#  index_report_parts_on_contract_id_and_report_id_and_role_id  (contract_id,report_id,role_id) UNIQUE
#  index_report_parts_on_report_id                              (report_id)
#  index_report_parts_on_role_id                                (role_id)
#
# Foreign Keys
#
#  fk_rails_...  (contract_id => contracts.id)
#  fk_rails_...  (report_id => reports.id)
#  fk_rails_...  (role_id => roles.id)
#

class ReportPart < ApplicationRecord
  belongs_to :report
  belongs_to :contract
  belongs_to :role, optional: true

  before_save :calculate_cost_and_days

  def rate_multiplier
    self.contract.contract_rate/self.report.reporting_period.base_rate
  end

  private

  def calculate_cost_and_days
    return true unless percentage

    self.cost = if report.user.rate&.value && report.user.dedication
                  (percentage / 100 * report.user.rate.value * report.user.dedication * rate_multiplier)
                end
    self.days = (percentage / 5.0 * (report.user&.dedication || 1.0)).round(2)
  end
end
