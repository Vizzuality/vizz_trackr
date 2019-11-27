# == Schema Information
#
# Table name: report_parts
#
#  id          :bigint           not null, primary key
#  report_id   :bigint           not null
#  percentage  :float
#  days        :float
#  cost        :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  contract_id :bigint           not null
#

class ReportPart < ApplicationRecord
  belongs_to :report
  belongs_to :contract

  before_save :calculate_cost_and_days
  validates_uniqueness_of :contract_id, scope: :report_id

  private

  def calculate_cost_and_days
    return true unless percentage

    self.cost = if report.user.cost
                  (percentage / 100 * report.user.cost / 0.74)
                end
    self.days = (percentage / 5.0).round(2)
  end
end
