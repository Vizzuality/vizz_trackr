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

class ProgressReport < ApplicationRecord
  belongs_to :reporting_period
  belongs_to :contract

  delegate :date, to: :reporting_period

  before_save :calculate_delta

  validates :reporting_period_id, uniqueness: {scope: :contract_id}
  validates :reporting_period_id, :contract_id, :percentage, presence: true
  validate :bounded_progress

  private

  def calculate_delta
    prev = contract.previous_progress_report(self)

    self.delta = if prev
      percentage - prev.percentage
    else
      percentage
    end
    # if editing an older progress, update the next one too
    next_one = contract.next_progress_report(self)

    next_one&.update_column(:delta, next_one.percentage - percentage)
  end

  def bounded_progress
    prev = contract.previous_progress_report(self)
    return unless prev && prev.percentage > percentage

    errors.add(:percentage, "Progress can't be lower than previously reported progress")
  end
end
