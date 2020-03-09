# == Schema Information
#
# Table name: contracts
#
#  id         :bigint           not null, primary key
#  name       :string
#  project_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  budget     :float
#  alias      :string           default([]), is an Array
#  start_date :date
#  end_date   :date
#  aasm_state :string
#  code       :string
#  notes      :text
#  summary    :text
#
require 'csv'

class Contract < ApplicationRecord
  include AASM
  include HasStateMachine

  aasm do
    state :proposal, initial: true
    state :live
    state :finished
    event :start do
      transitions from: :proposal, to: :live
    end
    event :finish do
      transitions from: :live, to: :finished
    end
    event :restart do
      transitions from: :finished, to: :live
    end
  end

  belongs_to :project
  has_many :report_parts # , dependent: :destroy
  has_many :full_reports
  has_many :non_staff_costs, dependent: :destroy
  has_many :monthly_incomes
  has_many :budget_lines
  accepts_nested_attributes_for :budget_lines, allow_destroy: true,
                                               reject_if: :reject_empty_lines

  has_many :progress_reports
  has_many :project_links, through: :project

  validates_uniqueness_of :name # , :code
  delegate :is_billable?, to: :project

  before_destroy :no_report_parts

  def full_name
    "#{name} [#{project.name}#{(' - internal' unless project.is_billable?)}]"
  end

  def latest_progress_report
    @latest_progress_report ||= progress_reports.joins(:reporting_period)
      .order('reporting_periods.date DESC').first
  end

  def previous_progress_report progress_report
    progress_reports.joins(:reporting_period)
      .where('reporting_periods.date < ?', progress_report.date)
      .order('reporting_periods.date DESC')&.first
  end

  def next_progress_report progress_report
    progress_reports
      .joins(:reporting_period)
      .where('reporting_periods.date > ?', progress_report.date)
      .order('reporting_periods.date ASC')
      .first
  end

  def build_budget_lines
    Role.order(:name).each do |role|
      budget_lines.build(role_id: role.id) unless budget_lines.where(role_id: role.id).any?
    end

    # one for extra
    budget_lines.build unless budget_lines.where(role_id: nil).any?
  end

  def total_burn with_projections = false
    relevant_reports = if with_projections
                         full_reports
                       else
                         full_reports.where(report_estimated: false)
                       end
    relevant_reports.sum(:cost) + non_staff_costs.sum(:cost)
  end

  def burn_percentage with_projections = false
    return nil unless budget

    ((total_burn(with_projections) / budget) * 100).round(2)
  end

  def income_to_date
    ((budget || 0) * (latest_progress_report&.percentage || 0) / 100).round(2)
  end

  def income_percentage
    latest_progress_report&.percentage || 0
  end

  def budget_left
    return 0 unless budget

    budget - budget * ((latest_progress_report&.percentage || 0) / 100)
  end

  # rubocop:disable Metrics/AbcSize
  def linear_income
    return nil unless budget && start_date && end_date

    progress = latest_progress_report
    start = progress ? (progress.date + 1.month) : start_date

    months = (end_date.year * 12 + end_date.month) - (start.year * 12 + start.month) + 1

    return budget_left if months <= 0

    (budget_left / months).to_f.round(2)
  end
  # rubocop:enable Metrics/AbcSize

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ['Project', 'Code', 'Contract', 'Start date', 'End Date',
              'Budget (EUR)', 'Internal?', 'Status']
      all.each do |contract|
        csv << [
          contract.project&.name,
          contract.code,
          contract.name,
          contract.start_date&.strftime('%d/%m/%Y'),
          contract.end_date&.strftime('%d/%m/%Y'),
          contract.budget,
          !contract.project.is_billable?,
          contract.aasm_state.humanize
        ]
      end
    end
  end

  private

  def reject_empty_lines(attributes)
    exists = attributes['id'].present?
    empty = attributes['percentage'].blank? || attributes['percentage'].to_f <= 0.0
    attributes.merge!(_destroy: 1) if exists && empty
    !exists && empty
  end

  def no_report_parts
    return unless report_parts.any?

    errors.add(:base, "Contract #{name} [#{code}] has time reported against it,"\
               ' please change those reports before trying to delete it again.')
    throw :abort
  end
end
