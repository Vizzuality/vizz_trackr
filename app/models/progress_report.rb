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

class ProgressReport < ApplicationRecord
  belongs_to :reporting_period
  belongs_to :contract

  delegate :date, to: :reporting_period

  before_save :calculate_delta

  validates_uniqueness_of :reporting_period_id, scope: :contract_id
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
  end

  def bounded_progress
    prev = contract.previous_progress_report(self)
    return unless prev && prev.percentage >= percentage

    errors.add(:percentage, 'Progress can\'t be lower than previously reported progress')
  end
end
