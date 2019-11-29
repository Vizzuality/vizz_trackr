# == Schema Information
#
# Table name: reporting_periods
#
#  id         :bigint           not null, primary key
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  aasm_state :string
#
require 'csv'

class ReportingPeriod < ApplicationRecord
  include AASM

    aasm do
    state :unstarted, initial: true
    state :active, before_enter: Proc.new{ ReportingPeriod.deactivate_active_reporting! }
    state :finished
    event :start do
    end
    event :activate do
      transitions from: :unstarted, to: :active
    end
    event :terminate do
      transitions from: :active, to: :finished
    end
    event :reactivate do
      transitions from: :finished, to: :active
    end
  end

  def self.deactivate_active_reporting!
    ReportingPeriod.where(aasm_state: 'active').each{|r| r.terminate!}
  end

  has_many :reports, dependent: :destroy
  has_many :report_parts, through: :reports
  has_many :contracts, through: :report_parts
  has_many :users, through: :reports

  has_many :full_reports

  validates_uniqueness_of :date

  def next_event
    self.aasm.events(permitted: true).first.name.to_s
  end

  def next_state
    self.aasm.states(permitted: true).first.name.to_s
  end

  def display_name
    date.strftime('%B %Y')
  end

  def total_contracts_reported
    full_reports.select(:contract_id).distinct.count
  end

  def total_time_reported
    full_reports.sum(:days)
  end

  def copy_reports_from source
    source.reports.each do |report|
      dupped = report.dup
      dupped.estimated = true
      report.report_parts.each do |part|
        dupped.report_parts << part.dup
      end
      reports << dupped
    end
  end

  def to_csv
    content = []
    users.order(:name).each do |user|
      data = {}
      data["staff"] = user.name
      report = reports.where(user_id: user.id).first
      contracts.order(:name).each do |contract|
        percentage = report.report_parts
          .where(contract_id: contract.id).pluck(:percentage).first
        data[contract.name] = percentage && (percentage / 100).round(2)
      end
      data['estimated'] = report.estimated?
      content << data
    end

    CSV.generate(headers: true, encoding: 'ISO-8859-1') do |csv|
      csv << content.first.keys
      content.each do |c|
        csv << c.values
      end
    end
  end

  def contracts_mean_variance_and_stdev filters
    contracts = full_reports
      .contracts_distribution(filters).first.try(:contracts)

    return {} unless contracts

    mean = contracts.inject { |sum, el| sum + el }.to_f / contracts.size

    step = contracts.inject(0) { |accum, i| accum + (i - mean)**2 }
    variance = contracts.size > 1 ? step / (contracts.size - 1).to_f : nil

    stdev = variance ? Math.sqrt(variance).try(:round, 2) : nil

    {
      contracts: contracts,
      mean: mean.round(2),
      variance: variance.try(:round, 2),
      stdev: stdev.try(:round, 2)
    }
  end

  # rubocop:disable Metrics/AbcSize
  def self.analyse filters
    result = []
    teams = Team.where(name: %w[K Rosling]).order(:name)

    ReportingPeriod.order(:date).each do |rp|
      next unless rp.full_reports.any?

      data = {rp: rp}
      teams.each do |t|
        filters_with_team = filters.merge(team_id: t.id)
        metrics = {}
        metrics[:total_contracts] = rp.full_reports
          .filtered(filters_with_team).select(:contract_id)
          .distinct.count

        metrics[:total_reporters] = rp.full_reports
          .filtered(filters_with_team).select(:user_id)
          .distinct.count

        metrics.merge!(rp.contracts_mean_variance_and_stdev(filters_with_team))

        data[t.name.to_sym] = metrics
      end
      result << data
    end
    result
  end
  # rubocop:enable Metrics/AbcSize
end
