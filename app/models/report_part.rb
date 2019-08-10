class ReportPart < ApplicationRecord
  belongs_to :report
  belongs_to :contract

  before_save :calculate_cost_and_days

  private
  def calculate_cost_and_days
    return true if !percentage
    self.cost = report.user.cost ?
      (percentage / 100 * report.user.cost * 0.74) : nil
    self.days = (percentage / 5.0).round(2)
  end
end
