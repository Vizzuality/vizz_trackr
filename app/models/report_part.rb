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

  validates :contract_id, uniqueness: {
    scope: :report_id,
    message: ->(object, _) do
      "Contract #{object.contract.name} added more than once."\
        'Please remove the duplicate entries before submitting your report again.'
    end
  }

  private

  # rubocop:disable Metrics/AbcSize
  def calculate_cost_and_days
    return true unless percentage

    self.cost = if report.user.rate&.value && report.user.dedication
                  (percentage / 100 * report.user.rate.value * report.user.dedication)
                end
    self.days = (percentage / 5.0 * (report.user&.dedication || 1.0)).round(2)
  end
  # rubocop:enable Metrics/AbcSize
end
